import 'package:flutter/material.dart';

class Detalleslistascreen extends StatelessWidget {
  final dynamic item;

  const Detalleslistascreen({super.key, required this.item});

  void abrirmodal(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nombre:${item["nombre"]}"),
          content: Column(
            children: [
              Text("Nombre:${item["informacion"]["latitud"]}"),
              Text("Nombre:${item["informacion"]["longitud"]}"),
              Image.network(
                "${item["informacion"]["imagen"]}",
                height: 300,
                width: 300,
                errorBuilder: (context, error, stackTrace) {
                  return Text("Error al cargar la imagen");
                },
              ),
            ],
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Regresar")),

      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text("Nombre:${item["nombre"]}"),
                Text("Sitio web:${item["informacion"]["sitio_web"]}"),
                Image.network(
                  "${item["informacion"]["imagen"]}",
                  height: 300,
                  width: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return Text("Error al cargar la imagen");
                  },
                ),

                FilledButton(
                  onPressed: () => abrirmodal(context),
                  child: Text("Ver mas detalles"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
