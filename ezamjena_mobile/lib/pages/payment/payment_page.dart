import 'dart:convert';

import 'package:ezamjena_mobile/model/product.dart';
import 'package:ezamjena_mobile/model/user.dart';
import 'package:ezamjena_mobile/pages/product_pages/product_overview.dart';
import 'package:ezamjena_mobile/pages/user_pages/my_profile_page.dart';
import 'package:ezamjena_mobile/providers/products_provider.dart';
import 'package:ezamjena_mobile/providers/user_provider.dart';
import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'package:ezamjena_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stripe_platform_interface/stripe_platform_interface.dart';

class PaymentPage extends StatefulWidget {
  static const String routeName = "/payment";
  final String productId; // Dodaj ovu liniju

  const PaymentPage(this.productId, {super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, dynamic>? paymentIntent;
  final _formKey = GlobalKey<FormState>();
  UserProvider? _userProvider = null;
  ProductProvider? _productProvider = null;
  User? user;
  Product? product;
  late String productId;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _productProvider = context.read<ProductProvider>();
    productId = widget.productId;
    loadData();
    loadProductDetails();
  }

  void loadProductDetails() async {
    // Ovdje dohvati podatke o proizvodu koristeći widget.productId
    try {
      var productData =
          await _productProvider?.getById(int.parse(widget.productId));
      if (productData != null) {
        setState(() {
          product = productData;
        });
      }
    } catch (error) {
      print("Error loading product data: $error");
    }
  }

  Future<void> loadData() async {
    try {
      var tempData = await _userProvider?.getById(LoggedInUser.userId);

      if (tempData != null) {
        setState(() {
          print('Data loaded successfully.' + tempData.toJson().toString());
          user = tempData;
        });
      } else {
        print('Data loading failed or returned null.');
      }
    } catch (error) {
      print('Error while loading data: $error');
    }
  }

  void makePayment() async {
    print("Pozvano");
    try {
      paymentIntent = await createPaymentIntent();

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "USD",
        testEnv: true,
      );

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "Ana",
        googlePay: gpay,
      ));

      // Present the Stripe payment sheet modal
      await Stripe.instance.presentPaymentSheet().then((value) {
        // This block will run after successful payment
        if (product != null) {
          print("Payment successful. Updating product status...");
          updateProductStatus(
              product!.id!, 1003); // Assuming 1003 is your 'paid' status
          showSuccessDialog();
        }
      }).catchError((e) {
        print("Payment failed: $e");
        showErrorDialog(e.toString());
      });
    } catch (e) {
      print("Error initializing payment: $e");
      showErrorDialog("Failed to initialize payment. Please try again.");
    }
  }

  Future<void> updateProductStatus(int productId, int? newStatus) async {
    if (_productProvider != null) {
      Product? currentProduct = await _productProvider!.getById(productId);
      if (currentProduct != null) {
        // Update only the status field
        currentProduct.statusProizvodaId = newStatus;

        // Log the product details to see what you are about to update
        print("Updating product with ID: $productId");
        print("New Status ID: $newStatus");
        print("Current Category ID: ${currentProduct.kategorijaProizvodaId}");

        // Perform the update
        var updatedProduct =
            await _productProvider!.update(productId, currentProduct.toJson());
        if (updatedProduct != null) {
          print("Product updated successfully.");
        } else {
          print("Failed to update the product.");
        }
      } else {
        print("Product not found.");
      }
    } else {
      print("Product provider is not initialized.");
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Done");
    } catch (e) {
      print("Failed");
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "1000",
        "currency": "USD",
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization":
                "Bearer sk_test_51PGQHG011Z43wOZRc2v9bm6lJc67E660Us3REj7uaXN1zsNiyQccnlDWTZTKOj8KpQNZMKHqxGGdpYc3Cw3HkMR400jxYsnnV4"
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                width: 200,
                height: 150,
                color:
                    Colors.grey, // Ovdje možete postaviti boju pozadine slike
                child: product != null
                    ? imageFromBase64String(product?.slika)
                    : Container(),
              ),
              SizedBox(width: 30),
              const SizedBox(height: 20),
              Text(
                'Naziv: ${product!.naziv}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Cijena:  ${product?.cijena}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Divider(),
              Text('Kupac:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Text(
                'Ime: ${user?.ime} ${user?.prezime}',
                style: const TextStyle(fontSize: 16),
              ),
              SizedBox(width: 5),
              Text(
                'Email: ${user?.email}',
                style: const TextStyle(fontSize: 16),
              ),
              SizedBox(width: 5),
              Text(
                'Adresa: ${user?.adresa}',
                style: const TextStyle(fontSize: 16),
              ),
              SizedBox(width: 5),
              Text(
                'Broj telefona: ${user?.telefon}',
                style: const TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyProfilePage.routeName);
                },
                child: Text(
                  'Vaši podaci nisu tačni? Uredite ih.',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  makePayment();
                },
                child: const Text('Pay with Stripe'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Your payment was successfully processed.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // This will close the AlertDialog
              Navigator.pushNamed(context, ProductListPage.routeName);
            },
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
