import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = "/product_details";
  String id;
 ProductDetailsPage(this.id,{super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: Container(
        child: Text(this.widget.id),
      ),
    );
  }
}
