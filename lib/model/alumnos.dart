import 'dart:convert';

class Alumno {
  String? id;
  String name;
  String lastname;
  String gender;
  String role;
  int age;

  Alumno({
    this.id,
    required this.name,
    required this.lastname,
    required this.gender,
    required this.role,
    required this.age,
  });

  factory Alumno.fromMap(Map<dynamic, dynamic> map, String id) {
    return Alumno(
      id: id,
      name: map['name'] as String? ?? '',
      lastname: map['lastname'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      role: map['role'] as String? ?? '',
      age: map['age'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastname': lastname,
      'gender': gender,
      'role': role,
      'age': age,
    };
  }
}
