import 'package:flutter/material.dart';
import 'package:test_flutter/views/weather_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_flutter/views/covid_form_view.dart';
import 'package:test_flutter/views/patients_list_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today Weather App',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Navigate to Weather Page
  void _navigateToWeather() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Weather')),
          body: WeatherView(),
        ),
      ),
    );
  }

  // Navigate to Covid Form
  void _navigateToCovidForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Covid Form')),
          body: CovidFormView(),
        ),
      ),
    );
  }

  // Navigate to Settings
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: const Center(
              child: Text('Settings', style: TextStyle(fontSize: 24))),
        ),
      ),
    );
  }

  // Navigate to Patients List
  void _navigateToPatientslist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Patients List')),
          body: const PatientsListView(),
        ),
      ),
    );
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
            _buildNavigationCard(
              title: 'Weather',
              icon: Icons.cloud,
              onTap: _navigateToWeather,
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              title: 'Covid Form',
              icon: Icons.calendar_today,
              onTap: _navigateToCovidForm,
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              title: 'Patients List',
              icon: Icons.people,
              onTap: _navigateToPatientslist,
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              title: 'Settings',
              icon: Icons.settings,
              onTap: _navigateToSettings,
            ),
          ],
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
