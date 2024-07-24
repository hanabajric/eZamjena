import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_desktop/model/user.dart';
import 'package:ezamjena_desktop/providers/user_provider.dart';

class TopThreeProfilesPage extends StatefulWidget {
  static const String routeName = '/top3Profiles';
  const TopThreeProfilesPage({Key? key}) : super(key: key);

  @override
  _TopThreeProfilesPageState createState() => _TopThreeProfilesPageState();
}

class _TopThreeProfilesPageState extends State<TopThreeProfilesPage> {
  List<User> topUsers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTopUsers();
  }

  Future<void> _loadTopUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      var allUsers = await userProvider.get(); // Fetching all users

      // Sorting and filtering logic for top users
      var sortedUsers = allUsers
          .where(
              (user) => user.brojKupovina != null && user.brojRazmjena != null)
          .toList()
        ..sort((a, b) => (b.brojKupovina! + b.brojRazmjena!)
            .compareTo(a.brojKupovina! + a.brojRazmjena!));

      topUsers = sortedUsers.take(3).toList();
    } catch (e) {
      print('Error loading top users: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Korisničko ime')),
                          DataColumn(label: Text('Grad')),
                          DataColumn(label: Text('Broj telefona')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Broj razmjena')),
                          DataColumn(label: Text('Broj kupovina')),
                          DataColumn(label: Text('Broj aktivnih artikala')),
                        ],
                        rows: topUsers.map<DataRow>((user) {
                          return DataRow(cells: [
                            DataCell(Text(user.korisnickoIme ?? 'N/A')),
                            DataCell(Text(user.nazivGrada ?? 'N/A')),
                            DataCell(Text(user.telefon ?? 'N/A')),
                            DataCell(Text(user.email ?? 'N/A')),
                            DataCell(Text(user.brojRazmjena.toString())),
                            DataCell(Text(user.brojKupovina.toString())),
                            DataCell(
                                Text(user.brojAktivnihArtikala.toString())),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
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
            ),
    );
  }
}
