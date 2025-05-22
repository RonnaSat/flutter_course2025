import 'package:flutter/material.dart';
import '../viewModels/covid_form_view_model.dart';

class CovidFormView extends StatefulWidget {
  const CovidFormView({super.key});

  @override
  State<CovidFormView> createState() => _CovidFormViewState();
}

class _CovidFormViewState extends State<CovidFormView> {
  final CovidFormViewModel _viewModel = CovidFormViewModel();
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: TextField(
                controller: _viewModel.firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name *',
                  border: OutlineInputBorder(),
                  errorText: _viewModel.firstNameError,
                ),
                onChanged: (value) {
                  _viewModel.setName(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _viewModel.lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name *',
                  border: OutlineInputBorder(),
                  errorText: _viewModel.lastNameError,
                ),
                onChanged: (value) {
                  _viewModel.setLastname(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth *',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                  errorText: _viewModel.dobError,
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2007),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    _viewModel.setDob(formattedDate);
                  }
                },
                controller: _viewModel.dobController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Gender *",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Radio<String>(
                        value: 'Male',
                        groupValue: _viewModel.selectedGender,
                        onChanged: (value) {
                          _viewModel.setGender(value!);
                        },
                      ),
                      const Text('Male'),
                      Radio<String>(
                        value: 'Female',
                        groupValue: _viewModel.selectedGender,
                        onChanged: (value) {
                          _viewModel.setGender(value!);
                        },
                      ),
                      const Text('Female'),
                    ],
                  ),
                  if (_viewModel.genderError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        _viewModel.genderError!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text("Symptoms *",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      if (_viewModel.symptomsError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _viewModel.symptomsError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _viewModel.symptoms.keys.map((symptom) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(symptom),
                        ),
                        Checkbox(
                          value: _viewModel.getSymptomValue(symptom),
                          onChanged: (value) {
                            _viewModel.setSymptoms(symptom);
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    // Submit form and get result
                    final errorMessage = await _viewModel.submitForm();

                    // Close loading dialog
                    Navigator.of(context).pop();

                    if (errorMessage == null) {
                      // Success case
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form Submitted Successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Error case
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _viewModel.clearForm();
                  },
                  child: const Text('Reset'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
