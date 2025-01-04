import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../styles/consts.dart';

class Sidebar extends StatefulWidget {
  final String currentRoute;

  const Sidebar({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late String activeRoute;

  @override
  void initState() {
    super.initState();
    _updateActiveRoute();
  }

  @override
  void didUpdateWidget(covariant Sidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRoute != widget.currentRoute) {
      _updateActiveRoute();
    }
  }

  void _updateActiveRoute() {
    setState(() {
      activeRoute = _normalizeRoute(widget.currentRoute);
    });
  }

  String _normalizeRoute(String route) {
    if (route.startsWith('/settings')) {
      return '/settings';
    }
    return route;
  }

  bool _isActive(String route) {
    return _normalizeRoute(route) == activeRoute;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double sidebarWidth;
    bool showText;

    if (screenWidth < 600) {
      sidebarWidth = 72;
      showText = false;
    } else if (screenWidth < 1200) {
      sidebarWidth = screenWidth * 0.25;
      showText = true;
    } else {
      sidebarWidth = 250;
      showText = true;
    }

    return Container(
      width: sidebarWidth,
      color: bgPrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showText)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/nimbuspulse_logo.svg',
                    width: 64,
                    height: 64,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome",
                    style: TextStyle(fontSize: 12, color: primaryTextColor),
                  ),
                  Text(
                    "Dilruba Başaran",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          if (showText) const Divider(color: secondaryTextColor),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: _buildMenuItems(showText),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(bool showText) {
    final menuItems = [
      {
        'icon': Icons.dashboard_outlined,
        'title': 'Dashboard',
        'route': '/dashboard'
      },
      {'icon': Icons.computer_outlined, 'title': 'Server', 'route': '/server'},
      {
        'icon': Icons.bar_chart_outlined,
        'title': 'Reports',
        'route': '/reports'
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Settings',
        'route': '/settings/settings_profile'
      },
      {
        'icon': Icons.logout,
        'title': 'Log Out',
        'route': '/login',
        'showActive': false
      },
    ];

    return menuItems.map((item) {
      final bool isActive =
          item['showActive'] != false && _isActive(item['route'] as String);

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: isActive ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: showText ? 24 : 16,
            vertical: 4,
          ),
          leading: Icon(
            item['icon'] as IconData,
            size: 20,
            color: isActive ? Colors.blue : secondaryTextColor,
          ),
          title: showText
              ? Text(
                  item['title'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontNunitoSans,
                    color: isActive ? Colors.blue : secondaryTextColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                )
              : null,
          onTap: () {
            setState(() {
              activeRoute = item['route'] as String;
            });
            Navigator.pushNamed(context, activeRoute);
          },
        ),
      );
    }).toList();
  }
}
