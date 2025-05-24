import 'package:flutter/material.dart';
import 'patient_detail_view.dart';
import '../models/covid_form_model.dart';
import '../viewModels/patient_view_model.dart';

class PatientsListView extends StatefulWidget {
  const PatientsListView({super.key});

  @override
  State<PatientsListView> createState() => _PatientsListViewState();
}

class _PatientsListViewState extends State<PatientsListView> {
  final PatientViewModel _viewModel = PatientViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
    _viewModel.initialize();
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
            onChanged: (value) {},
          ),
        ),
        Expanded(
          child: _viewModel.patients.isEmpty
              ? const Center(child: Text('No patients found'))
              : ListView.builder(
                  itemCount: _viewModel.patients.length,
                  itemBuilder: (context, index) {
                    final patient = _viewModel.patients[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(patient.name?[0] ?? ''),
                        ),
                        title: Text(patient.fullName),
                        subtitle: Text(
                            'Age: ${patient.ageInYears} - ${patient.symptomsList}'),
                        trailing: Text(patient.date ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PatientDetailView(patient: patient),
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
