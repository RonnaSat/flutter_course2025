class CovidFormModel {
  int? id;
  String? name;
  String? lastname;
  String? dob;
  int? age;
  String? gender;
  List<String> symptoms = [];
  String? date;
  
  CovidFormModel({
    this.id,
    this.name,
    this.lastname,
    this.dob,
    this.age,
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
}