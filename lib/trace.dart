import 'package:firebase_database/firebase_database.dart';
import 'package:roger_project/model/alumnos.dart';
import 'package:roger_project/widgets/box_widget.dart';
import 'package:flutter/material.dart';

class TraceScreen extends StatefulWidget {
  const TraceScreen({super.key});

  @override
  State<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends State<TraceScreen> {
  final controller = TextEditingController();
  List<Alumno> gente = [];
  final databaseRef = FirebaseDatabase.instance.ref().child('alumnos');

  @override
  void initState() {
    super.initState();
    _loadAlumnos();
  }

  void _loadAlumnos() {
    databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          gente = values.entries
              .map((entry) => Alumno.fromMap(
                  entry.value as Map<dynamic, dynamic>, entry.key))
              .toList();
        });
      }
    });
  }

  void searchPerson(String query) {
    setState(() {
      gente = gente.where((alumno) {
        return alumno.role.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void addAlumno(Alumno alumno) {
    databaseRef.push().set(alumno.toMap());
  }

  void deleteAlumno(String? id) {
    if (id != null) {
      databaseRef.child(id).remove();
    } else {
      print('Error: Intento de eliminar un alumno con ID nulo');
    }
  }

  void updateAlumno(Alumno alumno) {
    if (alumno.id != null) {
      databaseRef.child(alumno.id!).update(alumno.toMap());
    } else {
      print('Error: Intento de actualizar un alumno con ID nulo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trace Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 36, 16, 16),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Buscar por rol',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue))),
                onChanged: searchPerson,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                      onPressed: () {
                        setState(() {
                          gente = gente
                              .where((alumno) =>
                                  alumno.gender.toLowerCase() == 'female')
                              .toList();
                        });
                      },
                      icon: const Row(
                        children: [Icon(Icons.female), Text('Mujeres')],
                      )),
                  const SizedBox(
                    width: 50,
                  ),
                  IconButton.filled(
                      onPressed: () {
                        setState(() {
                          gente = gente
                              .where((alumno) =>
                                  alumno.gender.toLowerCase() == 'male')
                              .toList();
                        });
                      },
                      icon: const Row(
                        children: [Icon(Icons.male), Text('Hombres')],
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          gente = gente
                              .where((alumno) => alumno.age >= 18)
                              .toList();
                        });
                      },
                      child: const Text('Mayor de edad')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          gente =
                              gente.where((alumno) => alumno.age < 18).toList();
                        });
                      },
                      child: const Text('Menor de edad')),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              height: 500,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: gente.length,
                itemBuilder: (BuildContext context, int index) {
                  final alumno = gente[index];
                  return BoxWidget(
                    estudiante: alumno,
                    onEdit: (alumno) {
                      _showEditDialog(alumno);
                    },
                    onDelete: (id) {
                      deleteAlumno(id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(Alumno alumno) {
    final nameController = TextEditingController(text: alumno.name);
    final lastNameController = TextEditingController(text: alumno.lastname);
    final ageController = TextEditingController(text: alumno.age.toString());
    final roleController = TextEditingController(text: alumno.role);
    String gender = alumno.gender;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Alumno'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(labelText: 'Rol'),
                ),
                DropdownButton<String>(
                  value: gender,
                  items: <String>['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      gender = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                final updatedAlumno = Alumno(
                  id: alumno.id,
                  name: nameController.text,
                  lastname: lastNameController.text,
                  age: int.tryParse(ageController.text) ?? alumno.age,
                  role: roleController.text,
                  gender: gender,
                );
                updateAlumno(updatedAlumno);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final lastNameController = TextEditingController();
    final ageController = TextEditingController();
    final roleController = TextEditingController();
    String gender = 'Male';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir Nuevo Alumno'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(labelText: 'Rol'),
                ),
                DropdownButton<String>(
                  value: gender,
                  items: <String>['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      gender = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Añadir'),
              onPressed: () {
                final newAlumno = Alumno(
                  name: nameController.text,
                  lastname: lastNameController.text,
                  age: int.tryParse(ageController.text) ?? 0,
                  role: roleController.text,
                  gender: gender,
                );
                addAlumno(newAlumno);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
