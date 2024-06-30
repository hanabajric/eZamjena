import 'dart:convert';
import 'dart:io';
import 'package:ezamjena_desktop/pages/product_overview.dart';
import 'package:ezamjena_desktop/pages/purchase_history.dart';
import 'package:ezamjena_desktop/pages/request_history.dart';
import 'package:ezamjena_desktop/pages/request_overview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/mainPage';

  const MainPage({super.key});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 0; // Keeps track of the current tab index

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _tabController!.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController!.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('eZamjena'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Artikli'),
            Tab(text: 'Zahtjevi'),
            Tab(text: 'Historija Razmjene'),
            Tab(text: 'Historija Kupovina'),
            Tab(text: 'Profil'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          ProductOverviewPage(), // Your existing Products page
          RequestOverviewPage(), // Your new Requests page
          RequestHistoryPage(), // Placeholder for other pages
          PurchaseHistoryPage(),
          Container(child: Text("Profil")),
        ],
      ),
    );
  }
}
