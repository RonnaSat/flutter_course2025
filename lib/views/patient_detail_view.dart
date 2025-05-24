import 'package:flutter/material.dart';
import '../models/covid_form_model.dart';

class PatientDetailView extends StatelessWidget {
  final CovidFormModel patient;

  const PatientDetailView({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Text(
                  patient.name?[0] ?? '',
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            SizedBox(height: 24),
            _buildDetailCard('Patient Information', [
              _buildDetailRow('Name', patient.fullName),
              _buildDetailRow('Age', '${patient.ageInYears} years'),
              if (patient.gender != null)
                _buildDetailRow('Gender', patient.gender!),
            ]),
            SizedBox(height: 16),
            _buildDetailCard('Clinical Information', [
              _buildDetailRow('Symptoms', patient.symptomsList),
              _buildDetailRow('Admission Date', patient.date ?? ''),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
