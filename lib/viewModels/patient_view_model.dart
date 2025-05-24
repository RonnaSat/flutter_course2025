import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/covid_form_model.dart';

class PatientViewModel extends ChangeNotifier {
  final List<CovidFormModel> _patients = [];
  List<CovidFormModel> get patients => List.unmodifiable(_patients);

  void initialize() {
    fetchAndParseCovidForms().then((forms) {
      _patients.clear();
      _patients.addAll(forms);
      notifyListeners();
    });
  }

  Future<List<Map<String, dynamic>>> fetchCovidForms() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('covid_forms').get();
      List<Map<String, dynamic>> forms = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return forms;
    } catch (e) {
      debugPrint('Error fetching forms: $e');
      return [];
    }
  }

  Future<List<CovidFormModel>> fetchAndParseCovidForms() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('covid_forms').get();

      List<CovidFormModel> forms = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['submissionTimestamp'] as Timestamp?;

        return CovidFormModel(
          name: data['firstName'] as String?,
          lastname: data['lastName'] as String?,
          dob: data['dob'] as String?,
          gender: data['gender'] as String?,
          symptoms: (data['symptoms'] as List<dynamic>?)
                  ?.map((symptom) => symptom as String)
                  .toList() ??
              [],
          date: timestamp?.toDate(),
        );
      }).toList();
      return forms;
    } catch (e) {
      debugPrint('Error fetching and parsing forms: $e');
      return [];
    }
  }
}
