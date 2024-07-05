import 'package:ezamjena_desktop/model/city.dart';
import 'package:ezamjena_desktop/model/user.dart';
import 'package:ezamjena_desktop/providers/city_provider.dart';
import 'package:ezamjena_desktop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/allProfiles';
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? selectedCityId = null; // Default to 'Svi gradovi'
  String filterByUsername = '';
  List<User> users = [];
  List<City> cities = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadUsers();
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
      if (selectedCityId != null && selectedCityId != "") {
        searchQuery['grad.Id'] = selectedCityId;
      }

      var userProvider = Provider.of<UserProvider>(context, listen: false);
      var tmpData = await userProvider.get(searchQuery);
      if (tmpData != null) {
        setState(() {
          users = tmpData;
        });
      }
    } catch (e) {
      print("Failed to load users: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
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
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Pretraži po korisničkom imenu',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
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
          isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Korisničko ime')),
                        DataColumn(label: Text('Grad')),
                        DataColumn(label: Text('Broj telefona')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Broj razmjena')),
                        DataColumn(label: Text('Broj kupovina')),
                      ],
                      rows: users.map<DataRow>((user) {
                        return DataRow(cells: [
                          DataCell(Text(user.korisnickoIme ?? 'N/A')),
                          DataCell(Text(user.nazivGrada ?? 'N/A')),
                          DataCell(Text(user.telefon ?? 'N/A')),
                          DataCell(Text(user.email ?? 'N/A')),
                          DataCell(Text(user.brojRazmjena.toString())),
                          DataCell(Text(user.brojKupovina.toString())),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement the functionality to generate report
                },
                child: Text('Kreiraj izvještaj'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
