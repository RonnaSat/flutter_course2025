class CovidFormModel {
  String? name;
  String? lastname;
  String? dob;
  String? gender;
  List<String> symptoms = [];
  String? date;

  CovidFormModel({
    this.name,
    this.lastname,
    this.dob,
    this.gender,
    List<String>? symptoms,
    this.date,
  }) {
    if (symptoms != null) {
      this.symptoms = symptoms;
    }
  }

  // Helper method to get full name
  String get fullName => '$name ${lastname ?? ''}';

  // Helper method to get symptoms as a string
  String get symptomsList => symptoms.join(', ');

  int get ageInYears {
    if (dob != null) {
      DateTime birthDate = DateTime.parse(dob!);
      DateTime now = DateTime.now();
      return now.year - birthDate.year;
    }
    return 0;
  }
}
