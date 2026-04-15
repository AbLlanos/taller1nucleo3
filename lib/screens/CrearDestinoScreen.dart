import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Creardestinoscreen extends StatelessWidget {
  const Creardestinoscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear un destino")),

      body: formulario(context),
    );
  }
}

Widget formulario(context) {
  TextEditingController nombre = TextEditingController();
  TextEditingController ciudad = TextEditingController();
  TextEditingController pais = TextEditingController();
  TextEditingController coordenadas = TextEditingController();

  return Stack(
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text("Crear un destino"),

              Text("Debe llenar todos los campos obligatoriamente"),

              SizedBox(height: 5),

              TextField(
                controller: nombre,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese el nombre"),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                controller: ciudad,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese la ciudad"),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                controller: pais,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese el pais"),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                controller: coordenadas,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese las coordenadas"),
                ),
              ),

              SizedBox(height: 5),

              FilledButton(
                onPressed: () =>
                    guardar(nombre, ciudad, pais, coordenadas, context),
                child: Text("registro"),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

guardar(
  TextEditingController nombre,
  TextEditingController ciudad,
  TextEditingController pais,
  TextEditingController coordenadas,
  context,
) async {
  if (nombre.text.isEmpty ||
      ciudad.text.isEmpty ||
      pais.text.isEmpty ||
      coordenadas.text.isEmpty) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Todos los campos son obligatorios"),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  DatabaseReference ref = FirebaseDatabase.instance.ref("ubicaciones");

  DatabaseReference nuevo = ref.push();

  await nuevo.set({
    "id": nuevo.key,
    "uid": user.uid,
    "nombre": nombre.text,
    "ciudad": ciudad.text,
    "pais": pais.text,
    "coordenadas": coordenadas.text,
  });
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Éxito"),
        content: Text("Destino guardado correctamente"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text("Cerrar"),
          ),
        ],
      );
    },
  );
}
