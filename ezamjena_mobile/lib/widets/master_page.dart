import 'package:ezamjena_mobile/pages/product_pages/product_details.dart';
import 'package:ezamjena_mobile/pages/product_pages/product_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'ezamjena_drawer.dart';

class MasterPageWidget extends StatefulWidget {
  Widget? child;
  MasterPageWidget({this.child, Key? key}) : super(key: key);

  @override
  State<MasterPageWidget> createState() => _MasterPageWidgetState();
}

class _MasterPageWidgetState extends State<MasterPageWidget> {
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (currentIndex == 0) {
      Navigator.pushNamed(context, ProductListPage.routeName);
    } else if (currentIndex == 1) {
      //Navigator.pushNamed(context, CartScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: eZamjenaDrawer(),
      body: SafeArea(
        child: widget.child!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Dodaj artikal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Moj profil',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 0, 145, 255),
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
