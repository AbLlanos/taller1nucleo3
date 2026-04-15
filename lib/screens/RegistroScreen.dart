import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Registroscreen extends StatelessWidget {
  const Registroscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),

      body: formulario(context),
    );
  }
}

Widget formulario(context) {
  TextEditingController nombre = TextEditingController();
  TextEditingController edad = TextEditingController();
  TextEditingController celular = TextEditingController();
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
                controller: nombre,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese el nombre"),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                controller: edad,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese la edad"),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                controller: celular,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Ingrese su número de contacto"),
                ),
              ),

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
                onPressed: () =>
                    registro(nombre, edad, celular, email, password, context),
                child: Text("registro"),
              ),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, "login"),
                child: Text("Ya tienes una cuenta? Inicia sesión"),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

registro(
  TextEditingController nombre,
  TextEditingController edad,
  TextEditingController celular,
  TextEditingController email,
  TextEditingController password,
  context,
) async {
  if (nombre.text.isEmpty ||
      edad.text.isEmpty ||
      celular.text.isEmpty ||
      email.text.isEmpty ||
      password.text.isEmpty) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Todos los campos son obligatorios"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );

    return;
  }

  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

    final user = credential.user;

    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        "usuarios/${user.uid}",
      );

      await ref.set({
        "id": user.uid,
        "nombre": nombre.text,
        "edad": edad.text,
        "celular": celular.text,
        "email": email.text,
      });
    }

    Navigator.pushNamed(context, "login");
  } on FirebaseAuthException catch (e) {
    String message = "";

    switch (e.code) {
      case "weak-password":
        message = "La contraseña debe tener más de 6 caracteres";
        break;
      case "email-already-in-use":
        message = "Crendenciales en uso";
        break;
      case "invalid-email":
        message = "Formato de correo invalido";
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
  } catch (e) {
    print(e);
  }
}
