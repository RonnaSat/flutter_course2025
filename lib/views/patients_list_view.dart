import 'package:flutter/material.dart';
import 'patient_detail_view.dart';
import '../models/covid_form_model.dart';

class PatientsListView extends StatefulWidget {
  const PatientsListView({super.key});

  @override
  State<PatientsListView> createState() => _PatientsListViewState();
}

class _PatientsListViewState extends State<PatientsListView> {
  // This would typically come from a database or state management solution
  final List<CovidFormModel> _patients = [
    CovidFormModel(
      id: 1,
      name: 'John',
      lastname: 'Doe',
      age: 45,
      symptoms: ['Fever', 'Cough'],
      date: '2023-05-10',
    ),
    CovidFormModel(
      id: 2,
      name: 'Jane',
      lastname: 'Smith',
      age: 32,
      symptoms: ['Headache'],
      date: '2023-05-11',
    ),
    CovidFormModel(
      id: 3,
      name: 'Bob',
      lastname: 'Johnson',
      age: 58,
      symptoms: ['Fatigue', 'Shortness of breath'],
      date: '2023-05-09',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search Patients',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              // Implement search functionality
            },
          ),
        ),
        Expanded(
          child: _patients.isEmpty
              ? const Center(child: Text('No patients found'))
              : ListView.builder(
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(patient.name?[0] ?? ''),
                        ),
                        title: Text(patient.fullName),
                        subtitle: Text('Age: ${patient.age} - ${patient.symptomsList}'),
                        trailing: Text(patient.date ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientDetailView(patient: patient),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
