import 'package:ezamjena_desktop/key.dart';
import 'package:ezamjena_desktop/pages/all_profiles.dart';
import 'package:ezamjena_desktop/pages/main_page.dart';
import 'package:ezamjena_desktop/pages/product_overview.dart';
import 'package:ezamjena_desktop/pages/purchase_history.dart';
import 'package:ezamjena_desktop/pages/registration.dart';
import 'package:ezamjena_desktop/pages/request_history.dart';
import 'package:ezamjena_desktop/pages/request_overview.dart';
import 'package:ezamjena_desktop/pages/top3_profiles.dart';
import 'package:ezamjena_desktop/providers/buy_provider.dart';
import 'package:ezamjena_desktop/providers/city_provider.dart';
import 'package:ezamjena_desktop/providers/exchange_provider.dart';
import 'package:ezamjena_desktop/providers/product_category_provider.dart';
import 'package:ezamjena_desktop/providers/products_provider.dart';
import 'package:ezamjena_desktop/utils/logged_in_usser.dart';
import 'package:ezamjena_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => ProductCategoryProvider()),
      ChangeNotifierProvider(create: (_) => ExchangeProvider()),
      ChangeNotifierProvider(create: (_) => BuyProvider()),
      ChangeNotifierProvider(create: (_) => CityProvider()),
    ],
    child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black, // Promenite u tamniju boju koja se ističe
            unselectedLabelColor: Colors.grey, // Promenite za bolji kontrast
            labelStyle: TextStyle(fontSize: 16.0), // Stil za tekst
            unselectedLabelStyle: TextStyle(fontSize: 14.0),
          ),
        ),
        home: LoginPage(),
        onGenerateRoute: (settings) {
          if (settings.name == ProductOverviewPage.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const ProductOverviewPage()));
          }
          if (settings.name == RequestOverviewPage.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const RequestOverviewPage()));
          }
          if (settings.name == RequestHistoryPage.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const RequestHistoryPage()));
          }
          if (settings.name == RequestHistoryPage.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const PurchaseHistoryPage()));
          }
          if (settings.name == MainPage.routeName) {
            return MaterialPageRoute(builder: ((context) => const MainPage()));
          }
          if (settings.name == UserProfilePage.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const UserProfilePage()));
          }
          if (settings.name == TopThreeProfilesPage.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const TopThreeProfilesPage()));
          }
          if (settings.name == RegistrationPage.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const RegistrationPage()));
          }
          return null;
        }),
  ));
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login to Application"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context),
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: const Text('Nemate profil? Registrujte se!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Authorization.username = _usernameController.text;
      Authorization.password = _passwordController.text;

      var loggedInUserId = await userProvider?.getLoggedInUserId();
      if (loggedInUserId != null &&
          loggedInUserId.containsKey('userId') &&
          loggedInUserId.containsKey('userRole')) {
        LoggedInUser.userId = loggedInUserId['userId'];
        print("ovo je id logovanog usera ${LoggedInUser.userId}");
        if (loggedInUserId['userRole'] == "Administrator") {
          await userProvider.get();
          userProvider.setPasswordChanged(false);
          Navigator.pushNamed(context, MainPage.routeName);
        } else {
          // Korisnik nema odgovarajuću ulogu
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Pristup odbijen"),
              content: Text(
                  "Samo korisnici sa ulogom 'Administrator' mogu pristupiti aplikaciji."),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }
}
