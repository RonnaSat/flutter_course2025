import 'package:flutter/cupertino.dart';
import 'view/todo_view.dart';
import 'view/weather_view.dart';

// View
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: AppTabScaffold(),
    );
  }
}

class AppTabScaffold extends StatelessWidget {
  const AppTabScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cloud_sun),
            label: 'Weather',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return const TodoScreen();
              case 1:
                return const WeatherScreen();
              default:
                return const TodoScreen();
            }
          },
        );
      },
    );
  }
}
