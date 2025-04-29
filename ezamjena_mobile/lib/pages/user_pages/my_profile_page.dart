import 'package:email_validator/email_validator.dart';
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

class MyProfilePage extends StatefulWidget {
  static const String routeName = "/my_profile";

  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  UserProvider? _userProvider;
  CityProvider? _cityProvider;
  User? user;
  String? _selectedGrad;
  List<City> gradovi = [];

  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _korisnickoImeController = TextEditingController();
  TextEditingController _imeController = TextEditingController();
  TextEditingController _prezimeController = TextEditingController();
  TextEditingController _adresaController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _brojTelefonaController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordPotvrdaController = TextEditingController();
  bool _passwordVisible = false;
  bool _passwordConfirmationVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _cityProvider = context.read<CityProvider>();
    loadData();
    _loadCities();
  }

  Future<void> loadData() async {
    try {
      var tempData = await _userProvider?.getById(LoggedInUser.userId);
      if (tempData != null) {
        setState(() {
          user = tempData;
          _korisnickoImeController.text = user?.korisnickoIme ?? '';
          _imeController.text = user?.ime ?? '';
          _prezimeController.text = user?.prezime ?? '';
          _adresaController.text = user?.adresa ?? '';
          _emailController.text = user?.email ?? '';
          _brojTelefonaController.text = user?.telefon ?? '';
          _selectedGrad = user?.nazivGrada;
          _passwordController.text = user?.password ?? '';
        });
      }
    } catch (error) {
      print('Error while loading data: $error');
    }
  }

  Future<void> _loadCities() async {
    var tmpData = await _cityProvider?.get(null);
    setState(() {
      if (tmpData != null) {
        gradovi = tmpData;
      }
    });
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  Future<void> _handleSave(BuildContext context) async {
    try {
      if (user != null) {
        if (_imeController.text.isEmpty ||
            _prezimeController.text.isEmpty ||
            _adresaController.text.isEmpty ||
            _brojTelefonaController.text.isEmpty ||
            _emailController.text.isEmpty) {
          _showMissingFieldsDialog(context);
          return;
        }
        if (_passwordController.text.isNotEmpty &&
            _passwordController.text != _passwordPotvrdaController.text) {
          _showPasswordMismatchDialog(context);
          return;
        }

        // Ažuriranje korisnika
        user?.ime = _imeController.text;
        user?.prezime = _prezimeController.text;
        user?.adresa = _adresaController.text;
        user?.telefon = _brojTelefonaController.text;
        user?.email = _emailController.text;

        if (_selectedGrad != null) {
          var selectedCityID =
              gradovi.firstWhere((city) => city.naziv == _selectedGrad).id;
          user!.gradId = selectedCityID;
        }

        bool passwordChanged = _passwordController.text.isNotEmpty &&
            _passwordController.text != user?.password;

        var updatedUser = await _userProvider?.update(user!.id!, user);
        print('Ovo je updated user ime: ${user?.ime ?? 'nije dostupno'}');

        if (updatedUser != null) {
          if (passwordChanged) {
            _showPasswordChangedDialog(context);
          } else {
            _showDataChangedDialog(context);
          }
        } else {
          print('User data saved but password not changed.');
        }
      }
    } catch (e) {
      print('Error while updating user data: $e');
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

  void _showPasswordMismatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: "Nespješna promjena lozinke",
        message: "Lozinka i potvrda lozinke se ne podudaraju.",
        onOkPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showPasswordChangedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: "Uspješno ste promijenili lozinku",
        message:
            "Vaša lozinka je uspješno promijenjena. Molimo prijavite se ponovo sa novom lozinkom.",
        onOkPressed: () {
          Navigator.pop(context);
          _userProvider?.setPasswordChanged(true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
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
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _changeProfilePicture() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileBytes = File(pickedFile.path).readAsBytesSync();
      final String base64Stringg = base64String(fileBytes);
      setState(() {
        user?.slika = base64Stringg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Moj profil")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _changeProfilePicture,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: user?.slika != null
                      ? imageFromBase64String(user?.slika).image
                      : null,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _korisnickoImeController,
                decoration: InputDecoration(labelText: 'Korisničko ime'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ovo polje je obavezno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imeController,
                decoration: InputDecoration(labelText: 'Ime'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ovo polje je obavezno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prezimeController,
                decoration: InputDecoration(labelText: 'Prezime'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ovo polje je obavezno';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedGrad,
                decoration: InputDecoration(labelText: 'Grad'),
                items: gradovi.map((City grad) {
                  return DropdownMenuItem<String>(
                    value: grad.naziv,
                    child: Text(grad.naziv ?? ""),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGrad = value;
                  });
                },
              ),
              TextFormField(
                controller: _adresaController,
                decoration: InputDecoration(labelText: 'Adresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ovo polje je obavezno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _brojTelefonaController,
                decoration: InputDecoration(labelText: 'Broj telefona'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null &&
                      !RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
                    return 'Neispravan format broja telefona';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ovo polje je obavezno';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Neispravan format email-a';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Lozinka',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_passwordVisible,
              ),
              TextFormField(
                controller: _passwordPotvrdaController,
                decoration: InputDecoration(
                  labelText: 'Potvrda lozinke',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordConfirmationVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordConfirmationVisible =
                            !_passwordConfirmationVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_passwordConfirmationVisible,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _handleCancel,
                    child: Text("Odustani"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _handleSave(context);
                      }
                    },
                    child: Text("Spremi"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
