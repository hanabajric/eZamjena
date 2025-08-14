import 'package:ezamjena_desktop/pages/reports_page.dart';
import 'package:ezamjena_desktop/providers/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';
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
      ChangeNotifierProvider(create: (_) => ReportProvider()),
    ],
    child: MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontSize: 16.0),
          unselectedLabelStyle: TextStyle(fontSize: 14.0),
        ),
      ),
      home: LoginPage(),
      onGenerateRoute: (settings) {
        if (settings.name == ProductOverviewPage.routeName) {
          return MaterialPageRoute(
            builder: ((context) => const ProductOverviewPage()),
          );
        }
        if (settings.name == RequestOverviewPage.routeName) {
          return MaterialPageRoute(
              builder: ((context) => const RequestOverviewPage()));
        }
        if (settings.name == RequestHistoryPage.routeName) {
          return MaterialPageRoute(
              builder: (context) => const RequestHistoryPage());
        }
        if (settings.name == PurchaseHistoryPage.routeName) {
          return MaterialPageRoute(
              builder: (context) => const PurchaseHistoryPage());
        }
        if (settings.name == RequestHistoryPage.routeName) {
          return MaterialPageRoute(
            builder: ((context) => const RequestHistoryPage()),
          );
        }
        if (settings.name == ReportsPage.routeName) {
          return MaterialPageRoute(
            builder: ((context) => const ReportsPage()),
          );
        }
        if (settings.name == MainPage.routeName) {
          return MaterialPageRoute(builder: ((context) => const MainPage()));
        }
        if (settings.name == UserProfilePage.routeName) {
          return MaterialPageRoute(
            builder: ((context) => const UserProfilePage()),
          );
        }
        if (settings.name == TopThreeProfilesPage.routeName) {
          return MaterialPageRoute(
            builder: ((context) => const TopThreeProfilesPage()),
          );
        }
        if (settings.name == RegistrationPage.routeName) {
          return MaterialPageRoute(
            builder: ((context) => const RegistrationPage()),
          );
        }
        return null;
      },
    ),
  ));
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _updateFormValid() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("eZamjena"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Prijava',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Korisničko ime je obavezno';
                            }
                            return null;
                          },
                          onChanged: (_) => _updateFormValid(),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lozinka je obavezna';
                            }
                            return null;
                          },
                          onChanged: (_) => _updateFormValid(),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed:
                              _isFormValid ? () => _login(context) : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Nemate profil? Registrujte se!',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Authorization.username = _usernameController.text.trim();
      Authorization.password = _passwordController.text;

      var loggedInUserId = await userProvider?.getLoggedInUserId();
      if (loggedInUserId != null &&
          loggedInUserId.containsKey('userId') &&
          loggedInUserId.containsKey('userRole')) {
        LoggedInUser.userId = loggedInUserId['userId'];
        if (loggedInUserId['userRole'] == "Administrator") {
          await userProvider.get();
          userProvider.setPasswordChanged(false);
          Navigator.pushNamed(context, MainPage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Pristup odbijen"),
              content: const Text(
                  "Samo korisnici sa ulogom 'Administrator' mogu pristupiti aplikaciji."),
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
