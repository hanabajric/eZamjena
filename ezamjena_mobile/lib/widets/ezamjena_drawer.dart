import 'package:ezamjena_mobile/pages/product_pages/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pages/buy_pages/buy_history.dart';
import '../pages/exchange_pages/exchanege_requests.dart';
import '../pages/exchange_pages/exchange_history.dart';
import '../pages/product_pages/my_product_overview.dart';
import '../pages/product_pages/product_overview.dart';
import '../pages/product_pages/wishlist_overview.dart';
import '../providers/wishlistproduct_provider.dart';
import '../utils/logged_in_usser.dart';
import '../utils/utils.dart';
import 'custom_alert_dialog_YesNo.dart';

class eZamjenaDrawer extends StatefulWidget {
  const eZamjenaDrawer({super.key});

  @override
  State<eZamjenaDrawer> createState() => _eZamjenaDrawerState();
}

class _eZamjenaDrawerState extends State<eZamjenaDrawer> {
  int? _hovered; // indeks stavke nad kojom je miš

  /*────────────────────────── helper ──────────────────────────*/
  Widget _buildItem({
    required int index,
    required String title,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    final isHovered = _hovered == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click, // ➊ promijeni kursor
      onEnter: (_) => setState(() => _hovered = index),
      onExit: (_) => setState(() => _hovered = null),
      child: InkWell(
        // ➋ splash na mobitelu
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isHovered ? Colors.deepPurple.withOpacity(.08) : null,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: Icon(icon,
                color: isHovered ? Colors.deepPurple : Colors.black54),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isHovered ? Colors.deepPurple : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*────────────────────────── build ───────────────────────────*/
  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purple],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Spacer(),
                    Text('eZamjena',
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                    SizedBox(height: 2),
                    Text('Meni',
                        style: TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            /*────────────── stavke ──────────────*/
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _buildItem(
                    index: 0,
                    title: 'Home',
                    icon: Icons.home_outlined,
                    onTap: () => nav.pushNamed(ProductListPage.routeName),
                  ),
                  _buildItem(
                    index: 1,
                    title: 'Moji proizvodi',
                    icon: Icons.inventory_outlined,
                    onTap: () => nav.pushNamed(MyProductListPage.routeName),
                  ),
                  _buildItem(
                    index: 2,
                    title: 'Lista želja',
                    icon: Icons.favorite_border,
                    onTap: () => nav.pushNamed(WishlistScreen.routeName),
                  ),
                  _buildItem(
                    index: 3,
                    title: 'Zahtjevi za razmjenu',
                    icon: Icons.swap_horiz_outlined,
                    onTap: () => nav.pushNamed(ExchangeRequestsPage.routeName),
                  ),
                  _buildItem(
                    index: 4,
                    title: 'Historija razmjena',
                    icon: Icons.history_toggle_off,
                    onTap: () => nav.pushNamed(ExchangeHistoryPage.routeName),
                  ),
                  _buildItem(
                    index: 5,
                    title: 'Historija kupovina',
                    icon: Icons.shopping_bag_outlined,
                    onTap: () => nav.pushNamed(BuyHistoryPage.routeName),
                  ),
                  _buildItem(
                    index: 6,
                    title: 'Obavjesti',
                    icon: Icons.circle_notifications,
                    onTap: () => nav.pushNamed(NotificationsPage.routeName),
                  ),
                ],
              ),
            ),

            /*────────────── odjava ──────────────*/
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildItem(
                index: 6,
                title: 'Odjavi se',
                icon: Icons.logout,
                onTap: () => _showLogoutDialog(context),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /*────────────────────────── dialogs / helpers ───────────────*/
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog2(
        title: 'Odjava',
        message: 'Da li ste sigurni da želite da se odjavite?',
        onConfirmPressed: () {
          _logout(context);
        },
        onCancelPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _logout(BuildContext context) {
    Authorization.username = '';
    Authorization.password = '';
    LoggedInUser.userId = null;

    context.read<WishlistProductProvider>().clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (_) => false,
    );
  }
}
