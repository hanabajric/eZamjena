import 'package:ezamjena_mobile/pages/buy_pages/buy_history.dart';
import 'package:ezamjena_mobile/pages/product_pages/new_product.dart';
import 'package:ezamjena_mobile/pages/user_pages/my_profile_page.dart';
import 'package:ezamjena_mobile/pages/exchange_pages/exchange_history.dart';
import 'package:ezamjena_mobile/pages/product_pages/my_product_overview.dart';
import 'package:ezamjena_mobile/pages/product_pages/product_details.dart';
import 'package:ezamjena_mobile/pages/product_pages/product_overview.dart';
import 'package:ezamjena_mobile/pages/user_pages/registration.dart';
import 'package:ezamjena_mobile/providers/buy_provider.dart';
import 'package:ezamjena_mobile/providers/city_provider.dart';
import 'package:ezamjena_mobile/providers/exchange_provider.dart';
import 'package:ezamjena_mobile/providers/product_category_provider.dart';
import 'package:ezamjena_mobile/providers/products_provider.dart';
import 'package:ezamjena_mobile/providers/user_provider.dart';
import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'package:ezamjena_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ExchangeProvider()),
          ChangeNotifierProvider(create: (_) => BuyProvider()),
          ChangeNotifierProvider(create: (_) => ProductCategoryProvider()),
          ChangeNotifierProvider(create: (_) => CityProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: Colors.deepPurple,
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    primary: Colors.blue,
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ))),

            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            // textTheme: const TextTheme(
            //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            // ),
          ),
          home: HomePage(),
          onGenerateRoute: (settings) {
            if (settings.name == ProductListPage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => const ProductListPage()));
            }
            if (settings.name == MyProductListPage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => const MyProductListPage()));
            }
            if (settings.name == ExchangeHistoryPage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => const ExchangeHistoryPage()));
            }
            if (settings.name == BuyHistoryPage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => const BuyHistoryPage()));
            }
            if (settings.name == MyProfilePage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => const MyProfilePage()));
            }
             if (settings.name == RegistrationPage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => const RegistrationPage()));
            }
             if (settings.name == NewProductPage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => const NewProductPage()));
            }
            var uri = Uri.parse(settings.name!);
            if (uri.pathSegments.length == 2 &&
                "/${uri.pathSegments.first}" == ProductDetailsPage.routeName) {
              var id = uri.pathSegments[1];
              return MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(id));
            }
            return null;
          },
        )));

class HomePage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserProvider _userProvider;

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("eRazmjena"),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                // image: DecorationImage(
                //   // image: AssetImage(
                //   //     ),
                //   fit: BoxFit.cover,
                // ),
                ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: 0.8,
                      child: Text(
                        "Prijava na aplikaciju",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Opacity(
                      opacity: 0.9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:
                                            Color.fromARGB(181, 24, 24, 24))),
                              ),
                              child: TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(150, 27, 25, 25)),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(150, 27, 25, 25)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(233, 233, 236, 1),
                            Color.fromRGBO(44, 43, 43, 0.756),
                          ],
                        ),
                      ),
                      child: InkWell(
                          onTap: () async {
                            try {
                              Authorization.username = _usernameController.text;
                              Authorization.password = _passwordController.text;

                              var loggedInUserId =
                                  await _userProvider.getLoggedInUserId();
                              LoggedInUser.userId = loggedInUserId;

                              await _userProvider.get();
                              _userProvider.setPasswordChanged(false);
                              Navigator.pushNamed(
                                  context, ProductListPage.routeName);
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text("Error"),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                            child: Text("Ok"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ));
                            }
                          },
                          child: Center(
                              child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RegistrationPage.routeName);
                      },
                      child: Text(
                        "Nemate profil? Registrujte se!",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
