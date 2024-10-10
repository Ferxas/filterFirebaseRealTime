import 'package:roger_project/model/alumnos.dart';
import 'package:flutter/material.dart';

class BoxWidget extends StatelessWidget {
  final Alumno estudiante;
  final Function(Alumno) onEdit;
  final Function(Alumno) onDelete;

  BoxWidget({
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
      color: Colors.cyan.shade600,
      child: Column(
        children: [
          Text(estudiante.name),
          Text(estudiante.lastname),
          Text('${estudiante.age}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(Icons.edit), onPressed: () => onEdit(estudiante)),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => onDelete(estudiante)),
            ],
          )
        ],
      ),
    );
  }
}
