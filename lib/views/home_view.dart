import 'package:flutter/material.dart';
import 'package:test_flutter/viewModels/home_view_model.dart';
import 'package:test_flutter/views/weather_view.dart';
import 'package:test_flutter/views/covid_form_view.dart';
import 'package:test_flutter/views/patients_list_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome to My App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ..._buildNavigationCards(),
          ],
        ),
      ),
    );
  }

  // Screen creation methods moved from ViewModel
  Widget _getWeatherScreen() {
    return WeatherView();
  }

  Widget _getCovidFormScreen() {
    return CovidFormView();
  }

  Widget _getPatientsListScreen() {
    return const PatientsListView();
  }

  Widget _getSettingsScreen() {
    return const Center(
        child: Text('Settings', style: TextStyle(fontSize: 24)));
  }

  // Get screen widget by route
  Widget _getScreenByRoute(String route) {
    switch (route) {
      case 'weather':
        return _getWeatherScreen();
      case 'covid_form':
        return _getCovidFormScreen();
      case 'patients_list':
        return _getPatientsListScreen();
      case 'settings':
        return _getSettingsScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  List<Widget> _buildNavigationCards() {
    return _viewModel.navigationItems.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _buildNavigationCard(
          title: item.title,
          icon: item.icon,
          onTap: () => _navigateToScreen(item.route),
        ),
      );
    }).toList();
  }

  void _navigateToScreen(String route) {
    final Widget screen = _getScreenByRoute(route);
    final String title = _viewModel.getTitleByRoute(route);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: screen,
        ),
      ),
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
