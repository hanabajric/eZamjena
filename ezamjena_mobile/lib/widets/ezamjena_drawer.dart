import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

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
              Navigator.popAndPushNamed(context, ProductListPage.routeName);
            },
          ),
          ListTile(
            title: Text('Moji proizvodi'),
            onTap: () {
               Navigator.pushNamed(context, MyProductListPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
