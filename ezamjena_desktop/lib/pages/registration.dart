import 'dart:io';
import 'package:ezamjena_desktop/providers/user_provider.dart';
import 'package:ezamjena_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_desktop/model/city.dart';
import 'package:ezamjena_desktop/providers/city_provider.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _prezimeController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _korisnickoImeController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _adresaController = TextEditingController();
  String? _selectedCityId;
  List<City> _cities = [];
  CityProvider? _cityProvider = null;
  UserProvider? _userProvider = null;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _userProvider = context.read<UserProvider>();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      var tmpData = await _cityProvider?.getAnonymousCities();
      if (tmpData != null) {
        setState(() {
          _cities = tmpData;
        });
      }
    } catch (e, stacktrace) {
      print('Failed to load cities: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registracija")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: _image != null
                                ? DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover)
                                : null,
                            borderRadius: BorderRadius.circular(100)),
                        child: _image == null
                            ? Icon(Icons.camera_alt, color: Colors.white70)
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: buildTextFields() +
                      [buildDropdown(), buildRegisterButton()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? Function(String?)? validator,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12), // Add bottom padding to each field
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(),
          errorStyle:
              TextStyle(color: Colors.redAccent), // Style for the error text
          contentPadding:
              EdgeInsets.all(12), // Adjust padding inside the text field
        ),
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        autovalidateMode:
            AutovalidateMode.onUserInteraction, // Validates on every change
      ),
    );
  }

  List<Widget> buildTextFields() {
    return [
      buildTextField(
          controller: _imeController,
          label: 'Ime',
          hintText: 'Unesite svoje ime',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Ime je obavezno';
            return null;
          }),
      SizedBox(height: 10),
      buildTextField(
          controller: _prezimeController,
          label: 'Prezime',
          hintText: 'Unesite svoje prezime',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Prezime je obavezno';
            return null;
          }),
      SizedBox(height: 10),
      buildTextField(
          controller: _telefonController,
          label: 'Telefon',
          hintText: 'XXX/XXX-XXX',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (!RegExp(r'^[0-9]{3}\/[0-9]{3}-[0-9]{3}$').hasMatch(value ?? ""))
              return 'Telefon mora biti u formatu XXX/XXX-XXX';
            return null;
          }),
      SizedBox(height: 10),
      buildTextField(
          controller: _emailController,
          label: 'Email',
          hintText: 'email@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (!RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                .hasMatch(value ?? "")) return 'Unesite validan email';
            return null;
          }),
      SizedBox(height: 10),
      buildTextField(
          controller: _passwordController,
          label: 'Lozinka',
          hintText: 'Unesite lozinku',
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Lozinka je obavezna';
            if (value.length < 8)
              return 'Lozinka mora imati minimalno 8 karaktera';
            return null;
          }),
      SizedBox(height: 10),
      buildTextField(
          controller: _passwordConfirmController,
          label: 'Potvrdi lozinku',
          hintText: 'Potvrdite svoju lozinku',
          isPassword: true,
          validator: (value) {
            if (value != _passwordController.text)
              return 'Lozinke se ne poklapaju';
            return null;
          }),
      SizedBox(height: 10),
      buildTextField(
          controller: _adresaController,
          label: 'Adresa',
          hintText: 'Unesite svoju adresu',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Adresa je obavezna';
            return null;
          }),
    ];
  }

  Widget buildDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _selectedCityId,
      hint: Text("Odaberite grad"),
      onChanged: (newValue) {
        setState(() {
          _selectedCityId = newValue;
        });
      },
      items: _cities.map((City city) {
        return DropdownMenuItem<String>(
          value: city.id?.toString(),
          child: Text(city.naziv ?? "N/A"),
        );
      }).toList(),
    );
  }

  Widget buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_passwordController.text != _passwordConfirmController.text) {
          // Show an error message if passwords do not match
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Passwords do not match')),
          );
          return;
        }

        // Construct the user data
        var userData = {
          'ime': _imeController.text,
          'prezime': _prezimeController.text,
          'telefon': _telefonController.text,
          'email': _emailController.text,
          'korisnickoIme': _korisnickoImeController.text,
          'password': _passwordController.text,
          'passwordPotvrda': _passwordConfirmController.text,
          'adresa': _adresaController.text,
          'gradID': int.tryParse(
              _selectedCityId ?? '0'), // Assuming '0' is a valid placeholder
          'ulogaID': 1, // Assuming '1' for normal users, adjust as necessary
          'brojKupovina': null,
          'brojRazmjena': null,
          'brojAktivnihArtikala': null,
          'slika':
              _image != null ? base64String(await _image!.readAsBytes()) : null
        };

        try {
          // Use your provider to send the POST request
          await _userProvider!.insertUserWithoutAuth(userData);
          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful')),
          );
          // Optionally navigate the user or clear the form
        } catch (e) {
          // Handle errors, e.g., show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register: $e')),
          );
        }
      },
      child: Text('Registruj se'),
    );
  }
}
