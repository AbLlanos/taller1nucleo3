import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Historialscreen extends StatelessWidget {
  const Historialscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial"),
      ),
      body: listar());
  }
}

//Leer

Stream leer() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Stream.value([]);
  }

  return FirebaseDatabase.instance
      .ref("ubicaciones")
      .orderByChild("uid")
      .equalTo(user.uid)
      .onValue
      .map((event) {
    final snapshot = event.snapshot;

    if (!snapshot.exists || snapshot.value == null) {
      return [];
    }

    final data = Map.from(snapshot.value as Map);

    return data.entries.map((e) {
      return {
        ...Map.from(e.value),
        "id": e.key,
      };
    }).toList();
  });
}




//Listar

Widget listar() {
  return StreamBuilder(
    stream: leer(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("error1");
      }

      if (!snapshot.hasData) {
        return Text("error2");
      }

      final data = snapshot.data!;

      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];

          return Card(
            child: ListTile(
              title: Text("${item["nombre"]}"),
              subtitle: Column(
                children: [
                  Text("${item["ciudad"]}"),
                  Text("${item["pais"]}"),
                  Text("${item["coordenadas"]}"),

                  IconButton(onPressed: ()=> editar(context, item), icon: Icon(Icons.edit)),

                  IconButton(onPressed: ()=> eliminar(context, item["id"]), icon: Icon(Icons.delete)),

                ],
              ),

            ),
          );
        },
      );
    },
  );
}

editar(context, item) {
  TextEditingController nombre = TextEditingController(text: item["nombre"]);
  TextEditingController ciudad = TextEditingController(text: item["ciudad"]);
  TextEditingController coordenadas = TextEditingController(
    text: item["coordenadas"],
  );
  TextEditingController pais = TextEditingController(text: item["pais"]);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Edicion"),
        content: Column(
          children: [
            TextField(controller: nombre),

            TextField(controller: ciudad),

            TextField(controller: coordenadas),

            TextField(controller: pais),

            TextButton(
              onPressed: () async {
                await FirebaseDatabase.instance
                    .ref("ubicaciones/${item["id"]}")
                    .update({
                      "nombre": nombre.text,
                      "ciudad": ciudad.text,
                      "coordenadas": coordenadas.text,
                      "pais": pais.text,
                    });
                    Navigator.of(context).pop();
              },
              child: Text("Actualizar"),
            ),
          ],
        ),
      );
    },
  );
}

eliminar(context, String id) {
  return FirebaseDatabase.instance.ref("ubicaciones/$id").remove();
}
