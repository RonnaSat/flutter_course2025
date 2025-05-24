import 'package:flutter/material.dart';
import 'package:test_flutter/models/home_model.dart';

class HomeViewModel extends ChangeNotifier {
  // List of navigation items
  List<NavigationItem> get navigationItems => [
        NavigationItem(title: 'Weather', icon: Icons.cloud, route: 'weather'),
        NavigationItem(
            title: 'Covid Form',
            icon: Icons.calendar_today,
            route: 'covid_form'),
        NavigationItem(
            title: 'Patients List', icon: Icons.people, route: 'patients_list'),
        NavigationItem(
            title: 'Settings', icon: Icons.settings, route: 'settings'),
      ];

  // Get title for a specific route
  String getTitleByRoute(String route) {
    final item = navigationItems.firstWhere(
      (item) => item.route == route,
      orElse: () =>
          NavigationItem(title: 'Unknown', icon: Icons.error, route: ''),
    );
    return item.title;
  }
}
