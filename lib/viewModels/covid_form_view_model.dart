import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/covid_form_model.dart';

class CovidFormViewModel extends ChangeNotifier {
  CovidFormModel covidFormModel = CovidFormModel();

  // Controllers moved from view
  final TextEditingController dobController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String? selectedGender;

  // Validation error messages
  String? _firstNameError;
  String? _lastNameError;
  String? _dobError;
  String? _genderError;
  String? _symptomsError;

  // Getters for error messages
  String? get firstNameError => _firstNameError;
  String? get lastNameError => _lastNameError;
  String? get dobError => _dobError;
  String? get genderError => _genderError;
  String? get symptomsError => _symptomsError;

  // Map to track symptoms checkboxes
  final Map<String, bool> symptoms = {
    'Fever': false,
    'Cough': false,
    'Sore Throat': false,
    'Shortness of Breath': false,
    'Loss of Taste or Smell': false,
    'Fatigue': false,
    'Headache': false,
    'Muscle or Joint Pain': false,
    'Nausea or Vomiting': false,
    'Diarrhea': false,
  };

  void setName(String name) {
    covidFormModel.name = name;
    firstNameController.text = name; // Update controller text when setting name
    _validateFirstName();
    notifyListeners();
  }

  void setLastname(String lastname) {
    covidFormModel.lastname = lastname;
    lastNameController.text =
        lastname; // Update controller text when setting lastname
    _validateLastName();
    notifyListeners();
  }

  void setDob(String dob) {
    covidFormModel.dob = dob;
    dobController.text = dob; // Update controller text when setting DOB
    _validateDob();
    notifyListeners();
  }

  void setGender(String gender) {
    covidFormModel.gender = gender;
    selectedGender = gender; // Update selected gender
    _validateGender();
    notifyListeners();
  }

  // Validation methods
  bool _validateFirstName() {
    if (covidFormModel.name?.isEmpty ?? true) {
      _firstNameError = 'First name is required';
      return false;
    }
    _firstNameError = null;
    return true;
  }

  bool _validateLastName() {
    if (covidFormModel.lastname?.isEmpty ?? true) {
      _lastNameError = 'Last name is required';
      return false;
    }
    _lastNameError = null;
    return true;
  }

  bool _validateDob() {
    if (covidFormModel.dob?.isEmpty ?? true) {
      _dobError = 'Date of birth is required';
      return false;
    }
    _dobError = null;
    return true;
  }

  bool _validateGender() {
    if (covidFormModel.gender?.isEmpty ?? true) {
      _genderError = 'Gender is required';
      return false;
    }
    _genderError = null;
    return true;
  }

  bool _validateSymptoms() {
    if (!symptoms.values.any((value) => value == true)) {
      _symptomsError = 'At least one symptom must be selected';
      return false;
    }
    _symptomsError = null;
    return true;
  }

  // Overall form validation
  bool validateForm() {
    bool isValid = true;

    if (!_validateFirstName()) isValid = false;
    if (!_validateLastName()) isValid = false;
    if (!_validateDob()) isValid = false;
    if (!_validateGender()) isValid = false;
    if (!_validateSymptoms()) isValid = false;

    notifyListeners();
    return isValid;
  }

  void setSymptoms(String symptom) {
    symptoms[symptom] = !(symptoms[symptom] ?? false);

    if (symptoms[symptom] == true) {
      if (!covidFormModel.symptoms.contains(symptom)) {
        covidFormModel.symptoms.add(symptom);
      }
    } else {
      covidFormModel.symptoms.remove(symptom);
    }

    // Clear symptom error when a symptom is selected
    if (symptoms[symptom] == true) {
      _symptomsError = null;
    }

    notifyListeners();
  }

  bool getSymptomValue(String symptom) {
    return symptoms[symptom] ?? false;
  }

  void clearForm() {
    covidFormModel = CovidFormModel();
    firstNameController.clear();
    lastNameController.clear();
    dobController.clear();
    selectedGender = null;

    // Clear validation errors
    _firstNameError = null;
    _lastNameError = null;
    _dobError = null;
    _genderError = null;
    _symptomsError = null;

    // Reset all symptoms to false
    symptoms.updateAll((key, value) => false);
    notifyListeners();
  }

  Future<String?> submitForm() async {
    if (validateForm()) {
      try {
        await FirebaseFirestore.instance.collection('covid_forms').add({
          'firstName': covidFormModel.name,
          'lastName': covidFormModel.lastname,
          'dob': covidFormModel.dob,
          'gender': covidFormModel.gender,
          'symptoms': covidFormModel.symptoms,
          'submissionTimestamp': FieldValue.serverTimestamp(),
        });
        clearForm();
        return null; // Indicates success
      } catch (e) {
        // Log error instead of using print in production
        debugPrint('Error submitting form: $e');
        return e.toString(); // Return error message
      }
    } else {
      return 'Form validation failed.';
    }
  }
}
