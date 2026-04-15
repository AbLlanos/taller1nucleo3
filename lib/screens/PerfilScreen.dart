import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taller1nucleo3/screens/CrearDestinoScreen.dart';
import 'package:taller1nucleo3/screens/HistorialScreen.dart';
import 'package:taller1nucleo3/screens/ListaScreen.dart';

class Perfilscreen extends StatelessWidget {
  const Perfilscreen({super.key});

  @override
  Widget build(context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No hay usuario logueado")),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            Datos(user.uid),
            const Listascreen(),
            const Creardestinoscreen(),
            const Historialscreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.person)),
            Tab(icon: Icon(Icons.list)),
            Tab(icon: Icon(Icons.add)),
            Tab(icon: Icon(Icons.history)),
          ],
        ),
      ),
    );
  }
}
Widget Datos(String uid) {
  DatabaseReference ref = FirebaseDatabase.instance.ref("usuarios/$uid");

  return Center(
    child: StreamBuilder(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const CircularProgressIndicator();
        }

        final data = Map<String, dynamic>.from(
          snapshot.data!.snapshot.value as Map,
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bienvenido"),
            Text("Nombre: ${data["nombre"]}"),
            Text("Edad: ${data["edad"]}"),
            Text("Correo: ${data["email"]}"),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                // volver al login y limpiar historial
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "login",
                  (route) => false,
                );
              },
              child: const Text("Cerrar sesión"),
            ),
          ],
        );
      },
    ),
  );
}