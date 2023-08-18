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

class MyProfilePage extends StatefulWidget {
  static const String routeName = "/my_profile";

  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  UserProvider? _userProvider = null;
  CityProvider? _cityProvider = null;
  User? user;
  String? _selectedGrad;
  List<City> gradovi = [];
  bool _dataChanged = false;

  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _korisnickoImeController = TextEditingController();
  TextEditingController _imeController = TextEditingController();
  TextEditingController _prezimeController = TextEditingController();
  TextEditingController _adresaController = TextEditingController();
  TextEditingController _gradController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _brojTelefonaController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordPotvrdaController = TextEditingController();
  bool _passwordVisible = false;
  bool _passwordConfirmationVisible = false;
  String? _brojTelefonaError;
  String? _emailErrorText;
  String? _passwordErrorText;
  String? _passwordConfirmationErrorText;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
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
          print('Data loaded successfully.' + tempData.toJson().toString());
          user = tempData;
          _korisnickoImeController.text = user?.korisnickoIme ?? '';
          _imeController.text = user?.ime ?? '';
          _prezimeController.text = user?.prezime ?? '';
          _adresaController.text = user?.adresa ?? '';
          _gradController.text = user?.nazivGrada ?? '';
          _emailController.text = user?.email ?? '';
          _brojTelefonaController.text = user?.telefon ?? '';
          _selectedGrad = user?.nazivGrada;
          _passwordController.text = user?.password ?? '';
        });
      } else {
        print('Data loading failed or returned null.');
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
            _emailController.text.isEmpty ||
            _selectedGrad == null) {
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
        user!.gradId = selectedCityID;

        bool passwordChanged = _passwordController.text.isNotEmpty &&
            _passwordController.text != user?.password;

        var updatedUser = await _userProvider?.update(user!.id!, user);

        if (updatedUser != null) {
          if (_passwordController.text.isNotEmpty) {
            print('Mjenja se lozinka.');
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
          Navigator.pop(context); // Zatvaranje dijaloga
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
    return MasterPageWidget(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _changeProfilePicture();
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: user?.slika != null
                          ? imageFromBase64String(user?.slika).image
                          : null,
                    ),
                  ),
                  SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text("Broj razmjena: ${user?.brojRazmjena}"),
                      SizedBox(height: 20),
                      Text("Broj kupovina: ${user?.brojKupovina}"),
                      SizedBox(height: 20),
                      Text(
                          "Broj aktivnih artikala: ${user?.brojAktivnihArtikala}"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              TextFieldWithTitle(
                title: "Korisničko ime:",
                controller: _korisnickoImeController,
                onChanged: (value) {
                  setState(() {
                    user?.korisnickoIme = value;
                  });
                },
              ),
              TextFieldWithTitle(
                title: "Ime i prezime:",
                controller: TextEditingController(
                  text: '${_imeController.text} ${_prezimeController.text}',
                ),
                onChanged: (value) {
                  var parts = value.split(' ');
                  setState(() {
                    user?.ime = parts[0];
                    user?.prezime = parts.length > 1 ? parts[1] : '';
                  });
                },
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
                            user?.gradId = selectedCity.id;
                          });
                        },
                        items: gradovi.map((City grad) {
                          return DropdownMenuItem<String>(
                            value: grad.naziv,
                            child: Text(grad.naziv!),
                          );
                        }).toList(),
                        icon: Icon(Icons.arrow_drop_down),
                        isExpanded:
                            true, // Opcija za proširenje DropdownButton-a na širinu Expanded
                      ),
                      //),
                    ),
                  ],
                ),
              ),
              TextFieldWithTitle(
                title: "Adresa:",
                controller: _adresaController,
                onChanged: (value) {
                  setState(() {
                    user?.adresa = value;
                  });
                },
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
                      user?.telefon = value;
                    });
                  }
                },
                errorText: _brojTelefonaError,
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
                      user?.email = value;
                    });
                  }
                },
                errorText: _emailErrorText,
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
                      user?.password = value;
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
                    if (_passwordPotvrdaController.text != _passwordController.text) {
                      setState(() {
                        _passwordConfirmationErrorText =
                            "Lozinka i potvrda lozinke se ne podudaraju!";
                      });
                    } else {
                      setState(() {
                        _passwordConfirmationErrorText = null;
                        user?.password = value;
                     });
                  }
                },
                errorText: _passwordConfirmationErrorText,
                passwordField: true,
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
                    onPressed: (_passwordController.text ==
                                _passwordPotvrdaController.text) &&
                            _brojTelefonaError == null &&
                            _emailErrorText == null
                        ? () async {
                            _handleSave(
                                context); // Proslijedite trenutni context
                          }
                        : null,
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

class TextFieldWithTitle extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool passwordField;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? errorText;
  final String? emailErrorText;
  final String? passwordErrorText;
  final String? passwordConfirmationErrorText;

  const TextFieldWithTitle({
    required this.title,
    required this.controller,
    this.onChanged,
    this.passwordField = false,
    this.validator,
    this.keyboardType,
    this.errorText,
    this.emailErrorText,
    this.passwordErrorText,
    this.passwordConfirmationErrorText,
  });

  @override
  _TextFieldWithTitleState createState() => _TextFieldWithTitleState();
}

class _TextFieldWithTitleState extends State<TextFieldWithTitle> {
  bool _passwordVisible = false;
  bool _passwordConfirmationVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.title.toLowerCase().contains('lozinka');
    bool isConfirmationField =
        widget.title.toLowerCase().contains('potvrda lozinke');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(widget.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    obscureText: isPasswordField || isConfirmationField
                        ? (widget.passwordField ? !_passwordVisible : true)
                        : false,
                    validator: widget.validator,
                    keyboardType: widget.keyboardType,
                    decoration: InputDecoration(
                      errorText: widget.errorText ??
                          widget.emailErrorText ??
                          widget.passwordErrorText ??
                          widget.passwordConfirmationErrorText,
                      
                    ),
                    // Add more text field properties here
                  ),
                ),
              ),
              if (isPasswordField || isConfirmationField && widget.passwordField)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              // if (isConfirmationField && widget.passwordField)
              //   IconButton(
              //     onPressed: () {
              //       setState(() {
              //         _passwordConfirmationVisible =
              //             !_passwordConfirmationVisible;
              //       });
              //     },
              //     icon: Icon(
              //       _passwordConfirmationVisible
              //           ? Icons.visibility
              //           : Icons.visibility_off,
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
