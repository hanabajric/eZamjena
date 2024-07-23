import 'package:ezamjena_desktop/pages/top3_profiles.dart';
import 'package:flutter/material.dart';
import 'package:ezamjena_desktop/pages/all_profiles.dart';
import 'package:ezamjena_desktop/pages/product_overview.dart';
import 'package:ezamjena_desktop/pages/purchase_history.dart';
import 'package:ezamjena_desktop/pages/request_history.dart';
import 'package:ezamjena_desktop/pages/request_overview.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/mainPage';
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0; // Prati koji tab ili stranica je aktivna

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _handleProfileMenuSelection(String value) {
    setState(() {
      switch (value) {
        case 'All Profiles':
          _selectedIndex = 4; // Index UserProfilePage
          break;
        case 'Top 3 Profiles':
          _selectedIndex =
              5; // Index TopThreeProfilesPage, koji je van standardnih tabova
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      ProductOverviewPage(),
      RequestOverviewPage(),
      RequestHistoryPage(),
      PurchaseHistoryPage(),
      UserProfilePage(),
      TopThreeProfilesPage(), // Dodato kao opcija van redovnih tabova
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('eZamjena'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            if (index < 4) {
              // Ako nije "Profil" tab
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          tabs: [
            Tab(text: 'Artikli'),
            Tab(text: 'Zahtjevi'),
            Tab(text: 'Historija Razmjene'),
            Tab(text: 'Historija Kupovina'),
            MouseRegion(
              onEnter: (event) => _showProfileMenu(context, event.position),
              child: Tab(text: 'Profil'),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
    );
  }

  void _showProfileMenu(BuildContext context, Offset globalPosition) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          globalPosition.dx, globalPosition.dy, globalPosition.dx, 0),
      items: [
        PopupMenuItem(
          value: 'All Profiles',
          child: ListTile(
            leading: Icon(Icons.people),
            title: Text('Svi profili'),
            onTap: () => _handleProfileMenuSelection('All Profiles'),
          ),
        ),
        PopupMenuItem(
          value: 'Top 3 Profiles',
          child: ListTile(
            leading: Icon(Icons.star),
            title: Text('Top 3 profila'),
            onTap: () => _handleProfileMenuSelection('Top 3 Profiles'),
          ),
        ),
      ],
    );
  }
}
