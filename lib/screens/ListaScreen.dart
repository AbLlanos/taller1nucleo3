import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taller1nucleo3/screens/DetallesListaScreen.dart';

class Listascreen extends StatelessWidget {
  const Listascreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: listar(context));
  }
}

//leer
Future<List<dynamic>> leer(context) async {
  final data = await DefaultAssetBundle.of(
    context,
  ).loadString("assets/data/ciudades2.json");

  return json.decode(data)["ciudades"];
}

//listar

Widget listar(context) {
  return FutureBuilder<List<dynamic>> (
    future: leer(context),
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
                  Text("${item["provincia"]}"),
                  Text("${item["descripcion"]}"),

                  Image.network(
                    "${item["informacion"]["imagen"]}",
                    height: 200,
                    width: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Text("error al cargar imagen");
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detalleslistascreen(item: item),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}
