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

  // FUNCTIONS

  void _loadAlumnos() {
    databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        gente.clear();
        values.forEach((key, value) {
          gente.add(Alumno.fromMap(value, key));
        });
        setState(() {});
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

  void deleteAlumno(String id) {
    databaseRef.child(id).remove();
  }

  void updateAlumno(Alumno alumno) {
    databaseRef.child(alumno.id!).update(alumno.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
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
                      hintText: 'tema',
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
                        onPressed: () {},
                        icon: const Row(
                          children: [Icon(Icons.female), Text('Mujeres')],
                        )),
                    const SizedBox(
                      width: 50,
                    ),
                    IconButton.filled(
                        onPressed: () {},
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
                        onPressed: () {}, child: const Text('Mayor de edad')),
                    TextButton(
                        onPressed: () {}, child: const Text('Menor de edad')),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  height: 500,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    itemCount: gente.length,
                    itemBuilder: (BuildContext context, int index) {
                      final people = gente[index];
                      return BoxWidget(
                        estudiante: people,
                        onEdit: (alumno) {
                          // Implementa la lógica de edición aquí
                          // Por ejemplo, puedes abrir un diálogo de edición
                          _showEditDialog(alumno);
                        },
                        onDelete: (id) {
                          deleteAlumno(id);
                        },
                      );
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  Text('Rol'),
                  Container(
                    color: Colors.amber,
                    height: 50,
                    width: 200,
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddDialog();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showEditDialog(Alumno alumno) {}

  void _showAddDialog() {}
}
