import 'package:flutter/material.dart';

class SwipeBg extends StatelessWidget {                                       // Swipe para eliminar evaluaciones
  const SwipeBg({super.key, required this.alineacion, required this.color});

  final Alignment alineacion;
  final Color color;

  @override                                                                   // Método que construye el swipe
  Widget build(BuildContext context) {
    return Container(
      alignment: alineacion,                                                  // Alineacion
      padding: const EdgeInsets.symmetric(horizontal: 16),                    // Tamaño Fuente
      color: color,                                         // Color
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outlined, color: Colors.white), 
          SizedBox(width: 8),
          Text(
            "ELIMINAR",                                       // Texto del swipe
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
