import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taller1nucleo3/screens/PerfilScreen.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),

      body: formulario(context),
    );
  }
}

Widget formulario(context) {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  return Stack(
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text("Debe llenar todos los campos obligatoriamente"),

              SizedBox(height: 5),

              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese su correo electrónico o email"),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                controller: password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese su contraseña"),
                ),
              ),

              SizedBox(height: 5),

              FilledButton(
                onPressed: () => Login(email, password, context),
                child: Text("Iniciar sesión"),
              ),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, "registro"),
                child: Text("No tienes una cuenta? Registrate"),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Login(
  TextEditingController email,
  TextEditingController password,
  context,
) async {
  if (email.text.isEmpty || password.text.isEmpty) {
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

  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );

      Navigator.pushNamed(context, "perfil");

  } on FirebaseAuthException catch (e) {
    String message = "";

    switch (e.code) {
      case "user-not-found":
        message = "Credenciales no existen";
        break;
      case "wrong-password":
        message = "Credenciales invalidas";
        break;
              case "invalid-email":
        message = "Formato de correo inválido";
        break;

      default:
        message = "El código del error es : ${e.code}";
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
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
}
