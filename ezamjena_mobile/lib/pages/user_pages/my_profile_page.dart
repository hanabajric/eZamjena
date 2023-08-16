import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/city.dart';
import '../../model/user.dart';
import '../../providers/city_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
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
  UserProvider? _userProvider = null;
  CityProvider? _cityProvider = null;
  User? user;
  String? _selectedGrad;
  List<City> gradovi = [];
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

  Future<void> _handleSave() async {
    try {
      if (user != null) {
         var selectedCityID = gradovi
                              .firstWhere((city) => city.naziv == _selectedGrad).id;
        user!.gradId= selectedCityID;
        //user!.ulogaId = ;
        await _userProvider?.update(user!.id!,user);
        print('User data saved.');
      }
    } catch (e) {
      print('Error while updating user data: $e');
      
    }
  }

  Future<void> _changeProfilePicture() async {
    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource
            .gallery); 

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
                setState(() {
                  user?.telefon = value;
                });
              },
            ),
            TextFieldWithTitle(
              title: "Email:",
              controller: _emailController,
              onChanged: (value) {
                setState(() {
                  user?.email = value;
                });
              },
            ),
            TextFieldWithTitle(
              title: "Lozinka:",
              controller: _passwordController,
              onChanged: (value) {
                setState(() {
                  user?.password = value;
                });
              },
            ),
            TextFieldWithTitle(
              title: "Potvrda lozinke:",
              controller: _passwordPotvrdaController,
              onChanged: (value) {
                setState(() {
                  user?.password = value;
                });
              },
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
                  onPressed: _handleSave,
                  child: Text("Spremi"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithTitle extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final Widget? child;

  const TextFieldWithTitle({
    required this.title,
    required this.controller,
    this.onChanged,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    controller: controller,
                    onChanged: onChanged,
                    // Add more text field properties here
                  ),
                ),
              ),
            ],
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
