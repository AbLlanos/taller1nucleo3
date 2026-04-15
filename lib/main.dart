import 'package:flutter/material.dart';
import 'package:taller1nucleo3/firebase_options.dart';
import 'package:taller1nucleo3/screens/LoginScreen.dart';
import 'package:taller1nucleo3/screens/PerfilScreen.dart';
import 'package:taller1nucleo3/screens/RegistroScreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PlanificadorViajes());
}

class PlanificadorViajes extends StatelessWidget {
  const PlanificadorViajes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "login": (context) => Loginscreen(),
        "registro": (context) => Registroscreen(),
        "perfil": (context) => Perfilscreen(),
      },

      home: VentanaPrincipal(),
    );
  }
}

class VentanaPrincipal extends StatelessWidget {
  const VentanaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),

      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Text("Planificador de Viajes Personalizado", style: TextStyle(fontSize: 30), textAlign: TextAlign.center,),

                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, "login"),
                    child: Text("ir login"),
                  ),

                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, "registro"),
                    child: Text("ir registro"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
