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

  void _showEditDialog(User user) {
    TextEditingController usernameController =
        TextEditingController(text: user.korisnickoIme);
    TextEditingController nameController =
        TextEditingController(text: user.ime);
    TextEditingController surnameController =
        TextEditingController(text: user.prezime);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController phoneController =
        TextEditingController(text: user.telefon);
    TextEditingController addressController =
        TextEditingController(text: user.adresa);
    TextEditingController exchangeCountController =
        TextEditingController(text: user.brojRazmjena.toString());
    TextEditingController purchaseCountController =
        TextEditingController(text: user.brojKupovina.toString());
    TextEditingController activeArticleCountController =
        TextEditingController(text: user.brojAktivnihArtikala.toString());

    File? _imageFile;

    // Set initial selected city ID
    String? selectedCityId = user?.nazivGrada;

    Future<void> _pickImage(StateSetter setState) async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _imageFile = File(image.path));
      }
    }

    Future<List<City>> fetchCities() async {
      var cityProvider = Provider.of<CityProvider>(context, listen: false);
      return await cityProvider.get();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Pregled/uređivanje podataka o korisniku - ${user.korisnickoIme}'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await _pickImage(setState);
                      },
                      child: Container(
                        width: 200,
                        height: 230,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(_imageFile!),
                                  fit: BoxFit.cover)
                              : user.slika != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                          base64Decode(user.slika!)),
                                      fit: BoxFit.cover)
                                  : null,
                        ),
                        child: _imageFile == null && user.slika == null
                            ? Icon(Icons.camera_alt, color: Colors.white70)
                            : null,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                  labelText: 'Korisničko ime:')),
                          TextFormField(
                              controller: nameController,
                              decoration:
                                  InputDecoration(labelText: 'Ime i Prezime:')),
                          TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'Email:')),
                          TextFormField(
                              controller: phoneController,
                              decoration:
                                  InputDecoration(labelText: 'Broj telefona:')),
                          TextFormField(
                              controller: addressController,
                              decoration:
                                  InputDecoration(labelText: 'Adresa:')),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCityId,
                            onChanged: (String? newValue) {
                              setState(() => selectedCityId = newValue);
                            },
                            items: cities
                                .map<DropdownMenuItem<String>>((City city) {
                              return DropdownMenuItem<String>(
                                value: city.naziv,
                                child: Text(city.naziv!),
                              );
                            }).toList(),
                          ),
                          TextFormField(
                              controller: exchangeCountController,
                              decoration:
                                  InputDecoration(labelText: 'Broj razmjena:')),
                          TextFormField(
                              controller: purchaseCountController,
                              decoration:
                                  InputDecoration(labelText: 'Broj kupovina:')),
                          TextFormField(
                              controller: activeArticleCountController,
                              decoration: InputDecoration(
                                  labelText: 'Broj aktivnih artikala:')),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Spremi'),
              onPressed: () async {
                Map<String, dynamic> updateData = {
                  'ime': nameController.text,
                  'prezime': surnameController.text,
                  'email': emailController.text,
                  'telefon': phoneController.text,
                  'adresa': addressController.text,
                  'gradId': cities
                      .firstWhereOrNull((c) => c.naziv == selectedCityId)
                      ?.id,
                  'brojRazmjena': int.tryParse(exchangeCountController.text),
                  'brojKupovina': int.tryParse(purchaseCountController.text),
                  'brojAktivnihArtikala':
                      int.tryParse(activeArticleCountController.text),
                  'slika': _imageFile != null
                      ? base64String(await _imageFile!.readAsBytes())
                      : user.slika
                };

                if (_userProvider != null) {
                  await _userProvider!.adminUpdate(user.id, updateData);

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Podaci uspješno ažurirani!')));
                  _loadUsers();
                } else {
                  print('User provider not initialized');
                }
              },
            )
          ],
        );
      },
    );
  }
}
