import 'package:ezamjena_mobile/pages/buy_pages/buy_history.dart';
import 'package:ezamjena_mobile/pages/exchange_pages/exchanege_requests.dart';
import 'package:ezamjena_mobile/pages/payment/payment_page.dart';
import 'package:ezamjena_mobile/pages/product_pages/my_product_details.dart';
import 'package:ezamjena_mobile/pages/product_pages/new_product.dart';
import 'package:ezamjena_mobile/pages/product_pages/wishlist_overview.dart';
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
import 'package:ezamjena_mobile/providers/rating_provider.dart';
import 'package:ezamjena_mobile/providers/user_provider.dart';
import 'package:ezamjena_mobile/providers/wishlist_provider.dart';
import 'package:ezamjena_mobile/providers/wishlistproduct_provider.dart';
import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'package:ezamjena_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Osigurava inicijalizaciju
  Stripe.publishableKey =
      'pk_test_51PGQHG011Z43wOZRRgtya8rxE9Vu9myupCJh2NTCIh5Hu15jPQ44QawwkAKoh094qX18iUoEMLpw3sDYa0I2dExx00atU67guj';
  await Stripe.instance.applySettings();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ExchangeProvider()),
        ChangeNotifierProvider(create: (_) => BuyProvider()),
        ChangeNotifierProvider(create: (_) => ProductCategoryProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProductProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.deepPurple,
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
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
          if (settings.name == ExchangeRequestsPage.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const ExchangeRequestsPage()));
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
          if (settings.name == WishlistScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => const WishlistScreen()));
          }

          var uri = Uri.parse(settings.name!);
          if (uri.pathSegments.length == 2 &&
              "/${uri.pathSegments.first}" == ProductDetailsPage.routeName) {
            var id = uri.pathSegments[1];
            return MaterialPageRoute(
                builder: (context) => ProductDetailsPage(id));
          }
          if (uri.pathSegments.length == 2 &&
              "/${uri.pathSegments.first}" == MyProductDetailsPage.routeName) {
            var id = uri.pathSegments[1];
            return MaterialPageRoute(
                builder: (context) => MyProductDetailsPage(id));
          }
          if (uri.pathSegments.length == 2 &&
              "/${uri.pathSegments.first}" == PaymentPage.routeName) {
            var productId = uri.pathSegments[1];
            return MaterialPageRoute(
                builder: (context) => PaymentPage(productId));
          }
          return null;
        },
      )));
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserProvider _userProvider;
  bool _isObscured = true;

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
              image: DecorationImage(
                image: AssetImage('assets/images/login2.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), // Slight dark overlay
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Prijava na aplikaciju eZamjena",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(-1.5, -1.5),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(1.5, -1.5),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(1.5, 1.5),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(-1.5, 1.5),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
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
                                obscureText: _isObscured,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(150, 27, 25, 25)),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscured = !_isObscured;
                                      });
                                    },
                                  ),
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
                            Color.fromRGBO(71, 103, 148, 1),
                            Color.fromRGBO(255, 255, 255, 0.753),
                          ],
                        ),
                      ),
                      child: InkWell(
                          onTap: () async {
                            try {
                              Authorization.username = _usernameController.text;
                              Authorization.password = _passwordController.text;

                              var loggedInUserId =
                                  await _userProvider?.getLoggedInUserId();
                              if (loggedInUserId != null &&
                                  loggedInUserId.containsKey('userId') &&
                                  loggedInUserId.containsKey('userRole')) {
                                LoggedInUser.userId = loggedInUserId['userId'];
                                print(
                                    "ovo je id logovanog usera ${LoggedInUser.userId}");
                                if (loggedInUserId['userRole'] == "Klijent") {
                                  await _userProvider.get();
                                  _userProvider.setPasswordChanged(false);
                                  Navigator.pushNamed(
                                      context, ProductListPage.routeName);
                                } else {
                                  // Korisnik nema odgovarajuću ulogu
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text("Pristup odbijen"),
                                      content: Text(
                                          "Samo korisnici sa ulogom 'Klijent' mogu pristupiti aplikaciji."),
                                      actions: [
                                        TextButton(
                                          child: Text("Ok"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text("Greška"),
                                        content: Text(
                                            "Došlo je do greške prilikom prijave: $e.ToString()"),
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
