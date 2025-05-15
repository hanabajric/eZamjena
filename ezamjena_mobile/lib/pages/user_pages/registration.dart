import 'package:email_validator/email_validator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/city.dart';
import '../../model/user.dart';
import '../../providers/city_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/custom_alert_dialog.dart';
import '../../widets/master_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../widets/text_field_with_title.dart';
import '../../widets/alert_dialog_widet.dart';
import '../product_pages/product_overview.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = "/registration";

  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _korisnickoImeController =
      TextEditingController();
  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _prezimeController = TextEditingController();
  final TextEditingController _adresaController = TextEditingController();
  final TextEditingController _gradController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _brojTelefonaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordPotvrdaController =
      TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  UserProvider? _userProvider = null;
  CityProvider? _cityProvider = null;
  User user = User();
  String? _selectedGrad;
  List<City> gradovi = [];

  String? _passwordErrorText;
  String? _passwordConfirmationErrorText;
  String? _brojTelefonaError;
  String? _emailErrorText;
  String? _korImeErr, _imeErr, _prezimeErr, _gradErr;
  String? _passwordErr, _passwordConfErr, _phoneErr, _emailErr;
  final _phoneRe = RegExp(r'^\+\d{8,15}$');

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _cityProvider = context.read<CityProvider>();
    loadData();
    _loadCities();
  }

  Future<void> loadData() async {
    setState(() {
      _selectedGrad = "Izaberite Grad :";
    });
  }

  Future<void> _loadCities() async {
    try {
      var tmpData = await _cityProvider?.getAnonymousCities(null);
      print("TmpData: $tmpData");

      setState(() {
        if (tmpData != null) {
          gradovi = tmpData;
        }
        //_selectedGrad = "Izaberite Grad :";
      });
    } catch (e) {
      print("Error while loading cities: $e");
    }
  }

  Future<void> _addProfilePicture() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileBytes = File(pickedFile.path).readAsBytesSync();
      final String base64Stringg = base64String(fileBytes);

      setState(() {
        user.slika = base64Stringg;
      });
    } else {
      // Korisnik nije odabrao sliku, postavite user.slika na null
      setState(() {
        user.slika = null;
      });
    }
  }

  Future<void> _handleSave(BuildContext context) async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Provjerite označena polja.')),
      );
      return;
    }

    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _passwordPotvrdaController.text) {
      // Lozinka i potvrda lozinke nisu iste, prikažite obavijest
      _showPasswordMismatchDialog(context);
      return;
    }

    var selectedCityID =
        gradovi.firstWhere((city) => city.naziv == _selectedGrad).id;

    user.korisnickoIme = _korisnickoImeController.text;
    user.ime = _imeController.text;
    user.prezime = _prezimeController.text;
    user.adresa = _adresaController.text;
    user.gradId = selectedCityID;
    user.email = _emailController.text;
    user.telefon = _brojTelefonaController.text;
    user.password = _passwordController.text;
    user.passwordPotvrda = _passwordPotvrdaController.text;
    user.brojKupovina = 0;
    user.brojAktivnihArtikala = 0;
    user.brojRazmjena = 0;
    user.ulogaId = 2;

    try {
      await _userProvider?.insertUserWithoutAuth(user);
      await showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
          title: "Registracija uspješna!",
          message: "Uspješno ste kreirali svoj profil.",
          onOkPressed: () {
            Navigator.pop(context); // Zatvaranje dijaloga
          },
        ),
      );
      Authorization.username = _korisnickoImeController.text;
      Authorization.password = _passwordController.text;
      var loggedInUserId = await _userProvider?.getLoggedInUserId();
      LoggedInUser.userId = loggedInUserId?['userID'];

      Navigator.popAndPushNamed(context, ProductListPage.routeName);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext dialogContex) => AlertDialogWidget(
                title: "Greška",
                message: "Korisničko ime je zauzeto!",
                context: dialogContex,
              ));
    }
  }

  void _showMissingFieldsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: "Nedostajući podaci",
        message: "Molimo popunite sva obavezna polja.",
        onOkPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDataChangedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: "Uspješna promjena podataka",
        message: "Vaši podaci su uspješno promijenjeni.",
        onOkPressed: () {
          Navigator.pop(context); // Zatvaranje dijaloga
        },
      ),
    );
  }

  void _showPasswordMismatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: "Nespješna promjena lozinke",
        message: "Lozinka i potvrda lozinke se ne podudaraju.",
        onOkPressed: () {
          Navigator.pop(context); // Zatvaranje dijaloga
        },
      ),
    );
  }

  void _setErr(void Function() body) => setState(body);

  void _clearErrorsFor(String field) => _setErr(() {
        switch (field) {
          case 'korime':
            _korImeErr = null;
            break;
          case 'ime':
            _imeErr = null;
            break;
          case 'prezime':
            _prezimeErr = null;
            break;
          case 'email':
            _emailErr = null;
            break;
          case 'phone':
            _phoneErr = null;
            break;
          case 'pass':
            _passwordErr = null;
            _passwordConfErr = null;
            break;
        }
      });

  bool _validateForm() {
    _setErr(() {
      _korImeErr = _imeErr = _prezimeErr = _gradErr =
          _passwordErr = _passwordConfErr = _phoneErr = _emailErr = null;
    });

    bool ok = true;

    // obavezna polja
    if (_korisnickoImeController.text.trim().isEmpty) {
      _korImeErr = 'Obavezno polje';
      ok = false;
    }
    if (_imeController.text.trim().isEmpty) {
      _imeErr = 'Obavezno polje';
      ok = false;
    }
    if (_prezimeController.text.trim().isEmpty) {
      _prezimeErr = 'Obavezno polje';
      ok = false;
    }
    if (_emailController.text.trim().isEmpty) {
      _emailErr = 'Obavezno polje';
      ok = false;
    }
    if (_selectedGrad == null || _selectedGrad == 'Izaberite Grad :') {
      _gradErr = 'Obavezno polje';
      ok = false;
    }

    // e-mail
    if (_emailErr == null &&
        !EmailValidator.validate(_emailController.text.trim())) {
      _emailErr = 'Neispravan format e-maila';
      ok = false;
    }

    if (_brojTelefonaController.text.trim().isNotEmpty &&
        !_phoneRe.hasMatch(_brojTelefonaController.text.trim())) {
      _phoneErr = 'Predviđeni format: +38712345678';
      ok = false;
    }
    if (_passwordController.text.isEmpty) {
      _passwordErr = 'Obavezno polje';
      ok = false;
    } else if (_passwordController.text.length < 8) {
      _passwordErr = 'Lozinka mora imati mininalno 8 znakova';
      ok = false;
    }

    return ok;
  }

  void _validateEmail(String v) => _setErr(() {
        if (v.trim().isEmpty)
          _emailErr = 'Obavezno polje';
        else if (!EmailValidator.validate(v.trim()))
          _emailErr = 'Neispravan format e-maila';
        else
          _emailErr = null;
      });

  void _validatePhone(String v) => _setErr(() {
        if (v.trim().isEmpty)
          _phoneErr = null; // nije obavezno
        else if (!_phoneRe.hasMatch(v))
          _phoneErr = 'Format: +38712345678';
        else
          _phoneErr = null;
      });

  void _validatePass(String v) => _setErr(() {
        if (v.isEmpty)
          _passwordErr = 'Obavezno polje';
        else if (v.length < 8)
          _passwordErr = '≥ 8 znakova';
        else
          _passwordErr = null;

        // potvrda ažuriramo paralelno
        _passwordConfErr = (_passwordPotvrdaController.text != v)
            ? 'Lozinke se ne podudaraju'
            : null;
      });

  void _validateRequired(String v, String fieldKey) => _setErr(() {
        final err = v.trim().isEmpty ? 'Obavezno polje' : null;
        switch (fieldKey) {
          case 'korime':
            _korImeErr = err;
            break;
          case 'ime':
            _imeErr = err;
            break;
          case 'prezime':
            _prezimeErr = err;
            break;
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registracija")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _addProfilePicture();
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage: user.slika != null
                    ? imageFromBase64String(user.slika).image
                    : AssetImage("assets/placeholder_image.png"),
                child: user.slika == null ? Icon(Icons.add_a_photo) : null,
              ),
            ),
            TextFieldWithTitle(
              title: 'Korisničko ime:',
              controller: _korisnickoImeController,
              errorText: _korImeErr,
              onChanged: (v) => _validateRequired(v, 'korime'),
            ),
            TextFieldWithTitle(
              title: 'Ime:',
              controller: _imeController,
              errorText: _imeErr,
              onChanged: (v) => _validateRequired(v, 'ime'),
            ),
            TextFieldWithTitle(
              title: 'Prezime:',
              controller: _prezimeController,
              errorText: _prezimeErr,
              onChanged: (v) => _validateRequired(v, 'prezime'),
            ),
            TextFieldWithTitle(
              title: 'Adresa:',
              controller: _adresaController,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Grad:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(width: 94),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                          value: _selectedGrad,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          onChanged: (v) => setState(() {
                            _selectedGrad = v;
                            _gradErr = (_selectedGrad == null ||
                                    _selectedGrad == 'Izaberite Grad :')
                                ? 'Obavezno polje'
                                : null;
                          }),
                          items: [
                            const DropdownMenuItem(
                              value: 'Izaberite Grad :',
                              child: Text('Izaberite Grad :'),
                            ),
                            ...gradovi.map((g) => DropdownMenuItem(
                                  value: g.naziv,
                                  child: Text(g.naziv!),
                                )),
                          ],
                        ),
                        if (_gradErr != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _gradErr!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TextFieldWithTitle(
              title: 'Email:',
              controller: _emailController,
              errorText: _emailErr,
              onChanged: _validateEmail,
            ),
            TextFieldWithTitle(
              title: 'Broj telefona:',
              controller: _brojTelefonaController,
              errorText: _phoneErr,
              onChanged: _validatePhone,
            ),
            TextFieldWithTitle(
              title: 'Lozinka:',
              controller: _passwordController,
              passwordField: true,
              errorText: _passwordErr,
              onChanged: _validatePass,
            ),
            TextFieldWithTitle(
              title: 'Potvrda lozinke:',
              controller: _passwordPotvrdaController,
              passwordField: true,
              errorText: _passwordConfErr,
              onChanged: (v) => _setErr(() => _passwordConfErr =
                  (v != _passwordController.text)
                      ? 'Lozinke se ne podudaraju'
                      : null),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                onPressed: () async {
                  await _handleSave(context);
                },
                child: const Text('Registruj se'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
