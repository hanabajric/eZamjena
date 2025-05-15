import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ezamjena_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_desktop/model/city.dart';
import 'package:ezamjena_desktop/model/user.dart';
import 'package:ezamjena_desktop/providers/city_provider.dart';
import 'package:ezamjena_desktop/providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/allProfiles';
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? selectedCityId;
  String filterByUsername = '';
  List<User> users = [];
  List<City> cities = [];
  bool isLoading = false;
  UserProvider? _userProvider = null;
  File? _imageFile; // To hold the picked image file
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _loadCities();
    _loadUsers();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _loadCities() async {
    var cityProvider = Provider.of<CityProvider>(context, listen: false);
    var tmpData = await cityProvider.get();
    if (tmpData != null) {
      setState(() {
        cities = [City(id: null, naziv: "Svi gradovi")] + tmpData;
      });
    }
  }

  Future<void> _loadUsers() async {
    isLoading = true;
    try {
      Map<String, dynamic> searchQuery = {};
      if (filterByUsername.isNotEmpty) {
        searchQuery['KorisnickoIme'] = filterByUsername;
      }
      if (selectedCityId != null) {
        searchQuery['grad.Id'] = selectedCityId;
      }

      var tmpData = await _userProvider?.get(searchQuery);
      if (tmpData != null) {
        setState(() {
          users = tmpData;
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context)
        .size
        .width; // Screen width for dynamic adjustment

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05), // Horizontal padding
        child: Column(
          children: <Widget>[
            SizedBox(height: 20), // Adding some space at the top
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Local padding for the row
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centering row content
                children: <Widget>[
                  // Dropdown for cities
                  Expanded(
                    flex: 3, // Smaller part for the dropdown
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCityId,
                      hint: Text("Odaberite grad"),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCityId = newValue;
                          _loadUsers();
                        });
                      },
                      items: cities.map((City city) {
                        return DropdownMenuItem<String>(
                          value: city.id?.toString(),
                          child: Text(city.naziv ?? "N/A"),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 30), // Space between elements
                  // Search field
                  Expanded(
                    flex: 5, // Larger part for the search field
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Pretraži po korisničkom imenu',
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal:
                                20), // Reduced height and added horizontal padding
                      ),
                      onChanged: (value) {
                        setState(() {
                          filterByUsername = value;
                          _loadUsers();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? CircularProgressIndicator()
                  : users.isEmpty
                      ? Center(
                          child: Text('Trenutno nemate aktivnih korisnika'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Korisničko ime')),
                              DataColumn(label: Text('Grad')),
                              DataColumn(label: Text('Broj telefona')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Broj razmjena')),
                              DataColumn(label: Text('Broj kupovina')),
                              DataColumn(label: Text('Uredi')),
                              DataColumn(label: Text('Obriši')),
                            ],
                            rows: users.map<DataRow>((user) {
                              return DataRow(cells: [
                                DataCell(Text(user.korisnickoIme ?? 'N/A')),
                                DataCell(Text(user.nazivGrada ?? 'N/A')),
                                DataCell(Text(user.telefon ?? 'N/A')),
                                DataCell(Text(user.email ?? 'N/A')),
                                DataCell(Text(user.brojRazmjena.toString())),
                                DataCell(Text(user.brojKupovina.toString())),
                                DataCell(IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    if (_userProvider != null) {
                                      User? userDetails =
                                          await _userProvider?.getById(user.id);
                                      if (userDetails != null) {
                                        _showEditDialog(userDetails);
                                      } else {
                                        // Handle null userDetails, maybe show a message or log it
                                        print('User details not found');
                                      }
                                    } else {
                                      // Handle the case when _userProvider is still null
                                      print('User provider not initialized');
                                    }
                                  },
                                )),
                                DataCell(
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      if (user.id == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'User ID is missing, cannot delete the user.')));
                                        return;
                                      }
                                      try {
                                        await _userProvider?.delete(user.id!);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'User successfully deleted.')));
                                        _loadUsers(); // Refresh the list after deletion
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Failed to delete user: $e')));
                                        print('Error deleting user: $e');
                                      }
                                    },
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20, bottom: 20, top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    generateReport();
                  },
                  child: Text('Kreiraj izvještaj'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateReport() async {
    final fontData =
        await rootBundle.load('assets/fonts/NotoSans_Condensed-Regular.ttf');
    final byteData = ByteData.sublistView(fontData.buffer.asUint8List());
    final ttf = pw.Font.ttf(byteData);

    final pdf = pw.Document();
    String title = 'User Report';
    if (selectedCityId != null &&
        cities.any((c) => c.id.toString() == selectedCityId)) {
      title += ' for city ' +
          cities.firstWhere((c) => c.id.toString() == selectedCityId).naziv!;
    }
    if (filterByUsername.isNotEmpty) {
      title += ' filtered by username: $filterByUsername';
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title, style: pw.TextStyle(font: ttf, fontSize: 18)),
              pw.Divider(),
            ],
          ),
          pw.ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Username: ${user.korisnickoIme ?? 'N/A'}",
                      style: pw.TextStyle(font: ttf, fontSize: 14)),
                  pw.Text("City: ${user.nazivGrada ?? 'N/A'}",
                      style: pw.TextStyle(font: ttf, fontSize: 14)),
                  pw.Text("Phone: ${user.telefon ?? 'N/A'}",
                      style: pw.TextStyle(font: ttf, fontSize: 14)),
                  pw.Text("Email: ${user.email ?? 'N/A'}",
                      style: pw.TextStyle(font: ttf, fontSize: 14)),
                  pw.Text("Exchanges: ${user.brojRazmjena ?? '0'}",
                      style: pw.TextStyle(font: ttf, fontSize: 14)),
                  pw.Text("Purchases: ${user.brojKupovina ?? '0'}",
                      style: pw.TextStyle(font: ttf, fontSize: 14)),
                  pw.Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );

    // Trigger the file download or sharing process
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'user_report.pdf');
  }

  // ▼ ubaci negdje u klasi (npr. ispod _priceValidator)  ──────────────────────
  String? _req(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Obavezno polje' : null;

  String? _emailV(String? v) =>
      _req(v) ??
      (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v!.trim())
          ? 'Neispravan e‑mail'
          : null);

  String? _phoneV(String? v) =>
      _req(v) ??
      (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(v!) ? 'Neispravan broj' : null);

  Widget _tf(
    String label,
    TextEditingController c, {
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }

  Widget _dd(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
    String? Function(String?) validator,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

// ────────────────────────────────────────────────────────────────────────────
  void _showEditDialog(User user) {
    final _formKey = GlobalKey<FormState>();

    // ───── Kontroleri ─────
    final usernameC = TextEditingController(text: user.korisnickoIme);
    final nameC = TextEditingController(text: user.ime);
    final surnameC = TextEditingController(text: user.prezime);
    final emailC = TextEditingController(text: user.email);
    final phoneC = TextEditingController(text: user.telefon);
    final addressC = TextEditingController(text: user.adresa);
    final exchC = TextEditingController(text: user.brojRazmjena.toString());
    final buyC = TextEditingController(text: user.brojKupovina.toString());
    final activeC =
        TextEditingController(text: user.brojAktivnihArtikala.toString());

    String? selectedCity = user.nazivGrada;
    File? pickedImage;

    Future<void> _pickImage(StateSetter ss) async {
      final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
      if (img != null) ss(() => pickedImage = File(img.path));
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (ctx, ss) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ─── Header ───
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 8, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Uredi profil – ${user.korisnickoIme}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          splashRadius: 18,
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // ─── Body ───
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Slika
                            InkWell(
                              onTap: () => _pickImage(ss),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 200,
                                  height: 230,
                                  color: Colors.grey.shade300,
                                  child: pickedImage != null
                                      ? Image.file(pickedImage!,
                                          fit: BoxFit.cover)
                                      : user.slika != null
                                          ? imageFromBase64String(user.slika!)
                                          : const Icon(Icons.add_a_photo,
                                              size: 36, color: Colors.white70),
                                ),
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: Column(
                                children: [
                                  _tf('Korisničko ime *', usernameC,
                                      validator: _req),
                                  _tf('Ime *', nameC, validator: _req),
                                  _tf('Prezime *', surnameC, validator: _req),
                                  _tf('Email *', emailC,
                                      validator: _emailV,
                                      keyboard: TextInputType.emailAddress),
                                  _tf('Broj telefona *', phoneC,
                                      validator: _phoneV,
                                      keyboard: TextInputType.phone),
                                  _tf('Adresa', addressC),
                                  _dd(
                                    'Grad *',
                                    selectedCity,
                                    cities.map((c) => c.naziv!).toList(),
                                    (v) => ss(() => selectedCity = v),
                                    _req,
                                  ),
                                  _tf('Broj razmjena', exchC,
                                      keyboard: TextInputType.number),
                                  _tf('Broj kupovina', buyC,
                                      keyboard: TextInputType.number),
                                  _tf('Broj aktivnih artikala', activeC,
                                      keyboard: TextInputType.number),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ─── Footer ───
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Odustani'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            final payload = {
                              'ime': nameC.text.trim(),
                              'prezime': surnameC.text.trim(),
                              'email': emailC.text.trim(),
                              'telefon': phoneC.text.trim(),
                              'adresa': addressC.text.trim(),
                              'gradId': cities
                                  .firstWhereOrNull(
                                      (c) => c.naziv == selectedCity)
                                  ?.id,
                              'brojRazmjena': int.tryParse(exchC.text.trim()),
                              'brojKupovina': int.tryParse(buyC.text.trim()),
                              'brojAktivnihArtikala':
                                  int.tryParse(activeC.text.trim()),
                              'slika': pickedImage != null
                                  ? base64String(
                                      await pickedImage!.readAsBytes())
                                  : user.slika,
                            };

                            await _userProvider!.adminUpdate(user.id, payload);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Podaci uspješno ažurirani!')),
                            );
                            _loadUsers();
                          },
                          child: const Text('Spremi'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
