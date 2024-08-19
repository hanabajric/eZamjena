import 'package:ezamjena_mobile/main.dart';
import 'package:ezamjena_mobile/pages/exchange_pages/exchanege_requests.dart';
import 'package:ezamjena_mobile/providers/user_provider.dart';
import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'package:ezamjena_mobile/utils/utils.dart';
import 'package:ezamjena_mobile/widets/custom_alert_dialog.dart';
import 'package:ezamjena_mobile/widets/custom_alert_dialog_YesNo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../pages/buy_pages/buy_history.dart';
import '../pages/exchange_pages/exchange_history.dart';
import '../pages/product_pages/my_product_overview.dart';
import '../pages/product_pages/product_overview.dart';

class eZamjenaDrawer extends StatelessWidget {
  eZamjenaDrawer({Key? key}) : super(key: key);
  //CartProvider? _cartProvider;
  @override
  Widget build(BuildContext context) {
    //_cartProvider = context.watch<CartProvider>();
    print("called build drawer");
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, ProductListPage.routeName);
            },
          ),
          ListTile(
            title: Text('Moji proizvodi'),
            onTap: () {
              Navigator.pushNamed(context, MyProductListPage.routeName);
            },
          ),
          ListTile(
            title: Text('Zahtjevi za razmjenu'),
            onTap: () {
              Navigator.pushNamed(context, ExchangeRequestsPage.routeName);
            },
          ),
          ListTile(
            title: Text('Historija razmjena'),
            onTap: () {
              Navigator.pushNamed(context, ExchangeHistoryPage.routeName);
            },
          ),
          ListTile(
            title: Text('Historija kupovina'),
            onTap: () {
              Navigator.pushNamed(context, BuyHistoryPage.routeName);
            },
          ),
          ListTile(
            title: Text('Odjavi se'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => CustomAlertDialog2(
                  title: "Odjava",
                  message: "Da li ste sigurni da želite da se odjavite?",
                  onConfirmPressed: () {
                    logout(
                        context); // This will handle logging out and redirecting to the login page
                  },
                  onCancelPressed: () {
                    Navigator.of(context).pop(); // Just close the dialog
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    // Clearing the authentication details
    Authorization.username = '';
    Authorization.password = '';
    LoggedInUser.userId =
        null; // Assuming 'userId' can be set to null or similar

    // Clearing any user-specific data stored in providers or elsewhere
    Provider.of<UserProvider>(context, listen: false).clearUserData();

    // Vraćanje na početni ekran
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }
}
