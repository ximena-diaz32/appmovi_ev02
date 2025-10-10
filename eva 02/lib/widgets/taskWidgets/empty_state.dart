import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {                            // WIdget de estado vacio
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checklist_rtl, size: 64, color: const Color.fromARGB(255, 31, 115,117)),
            SizedBox(height: 12),
            Text(
              "No hay Evaluaciones",                                // Mensaje sino hay evaluaciones
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "Agregue sus evaluaciones desde el botón + Agendar", // Mensaje de instruccion para ingresar evaluaciones
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
