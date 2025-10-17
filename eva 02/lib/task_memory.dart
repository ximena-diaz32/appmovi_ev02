import 'package:flutter/material.dart';

class TaskMemory extends StatelessWidget {
  const TaskMemory({super.key});

  @override                                                                                                    // Método que construye el widget
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 31, 115, 117),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,                                                      // Centra verticalmente
            children: [
              Image.network(
                "https://i.ibb.co/SwVPLpjZ/strickland.png",                                                   // S. Strickland
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),                                                                     // Espacio entre imagen y texto
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'PARA OBTENER UNA NUEVA CONTRASEÑA POR FAVOR DIRÍJASE A LA OFICINA DEL SR. STRICKLAND.',    // Instrucción fundamental para la recuperación de contraseñas
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
