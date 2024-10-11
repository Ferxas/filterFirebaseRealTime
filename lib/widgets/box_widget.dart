import 'package:flutter/material.dart';
import 'package:roger/model/alumnos.dart';

class BoxWidget extends StatelessWidget {
  final Alumno estudiante;
  final Function(Alumno) onEdit;
  final Function(String?) onDelete;

  const BoxWidget({
    Key? key,
    required this.estudiante,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${estudiante.name} ${estudiante.lastname}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Edad: ${estudiante.age}', style: TextStyle(fontSize: 16)),
          Text('Rol: ${estudiante.role}', style: TextStyle(fontSize: 16)),
          Text('Género: ${estudiante.gender}', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => onEdit(estudiante),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onDelete(estudiante.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
