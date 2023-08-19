import 'package:email_validator/email_validator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
    var tmpData = await _cityProvider?.get(null);
    setState(() {
      if (tmpData != null) {
        gradovi = tmpData;
      }
      _selectedGrad = "Izaberite Grad :";
    });
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
    }
  }

  Future<void> _handleSave(BuildContext context) async {
    try {
      if (_imeController.text.isEmpty ||
          _prezimeController.text.isEmpty ||
          _adresaController.text.isEmpty ||
          _brojTelefonaController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _selectedGrad == null) {
        print(_imeController.text);
        print(_prezimeController.text);
        _showMissingFieldsDialog(context);
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
      user.ulogaId = 2;

      var createdUser = await _userProvider?.insert(user);

      if (createdUser != null) {
        _showDataChangedDialog(context);
      } else {
        print('Failed to create user.');
      }
    } catch (e) {
      print('Error while creating user: $e');
    }
  }

  void _showMissingFieldsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: "Nedostajući podaci",
        message: "Molimo popunite sva obavezna polja.",
        onOkPressed: () {
          Navigator.pop(context); // Zatvaranje dijaloga
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
              ),
            ),
            TextFieldWithTitle(
              title: "Korisničko ime:",
              controller: _korisnickoImeController,
            ),
            TextFieldWithTitle(
              title: "Ime:",
              controller: _imeController,
            ),
            TextFieldWithTitle(
              title: "Prezime:",
              controller: _prezimeController,
            ),
            TextFieldWithTitle(
              title: "Adresa:",
              controller: _adresaController,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Grad:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(
                        width: 94,
                      ),
                    ],
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedGrad,
                      onChanged: (newValue) async {
                        setState(() {
                          _selectedGrad = newValue!;
                          var selectedCity = gradovi
                              .firstWhere((city) => city.naziv == newValue);
                          user.gradId = selectedCity.id;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: "Izaberite Grad :",
                          child: Text("Izaberite Grad :"),
                        ),
                        ...gradovi.map((City grad) {
                          return DropdownMenuItem<String>(
                            value: grad.naziv,
                            child: Text(grad.naziv!),
                          );
                        }).toList(),
                      ],
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
            ),
            TextFieldWithTitle(
              title: "Email:",
              controller: _emailController,
              onChanged: (value) {
                if (!EmailValidator.validate(value)) {
                  setState(() {
                    _emailErrorText = "Neispravan format email-a!";
                  });
                } else {
                  setState(() {
                    _emailErrorText = null;
                    //user?.email = value;
                  });
                }
              },
              errorText: _emailErrorText,
            ),
            TextFieldWithTitle(
              title: "Broj telefona:",
              controller: _brojTelefonaController,
              onChanged: (value) {
                if (!value
                    .startsWith(RegExp(r'^[0-9]{3}\/[0-9]{3}-[0-9]{3}$'))) {
                  setState(() {
                    _brojTelefonaError = "Neispravan format broja telefona!";
                  });
                } else {
                  setState(() {
                    _brojTelefonaError = null;
                    //user?.telefon = value;
                  });
                }
              },
              errorText: _brojTelefonaError,
            ),
            TextFieldWithTitle(
              title: "Lozinka:",
              controller: _passwordController,
              onChanged: (value) {
                if (value.length < 8) {
                  setState(() {
                    _passwordErrorText =
                        "Minimalna dužina lozinke je 8 karaktera!";
                  });
                } else {
                  setState(() {
                    _passwordErrorText = null;
                    user.password = value;
                  });
                }
              },
              errorText: _passwordErrorText,
              passwordField: true,
            ),
            TextFieldWithTitle(
              title: "Potvrda lozinke:",
              controller: _passwordPotvrdaController,
              onChanged: (value) {
                if (_passwordPotvrdaController.text !=
                    _passwordController.text) {
                  setState(() {
                    _passwordConfirmationErrorText =
                        "Lozinka i potvrda lozinke se ne podudaraju!";
                  });
                } else {
                  setState(() {
                    _passwordConfirmationErrorText = null;
                    user.password = value;
                  });
                }
              },
              errorText: _passwordConfirmationErrorText,
              passwordField: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_passwordController.text ==
                          _passwordPotvrdaController.text) &&
                      _passwordController.text.length >= 8 &&
                      _passwordPotvrdaController.text ==
                          _passwordController.text &&
                      _selectedGrad != "Izaberite Grad :"
                  ? () async {
                      _handleSave(context);
                    }
                  : null,
              child: Text("Registriraj se"),
            ),
          ],
        ),
      ),
    );
  }
}
