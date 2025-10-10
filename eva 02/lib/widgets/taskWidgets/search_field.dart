import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {                     // Campo de busqueda
  const SearchField({super.key, required this.onChanged});      // Contructor con parametro para cmabios
  final ValueChanged<String> onChanged;                         // Funcion que se ejecuta al cambiar el texto

  @override
  Widget build(BuildContext context) {                          // Metodo que construye el widget
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),        // Padding
      child: TextField(
        onChanged: onChanged,                                   // Ejecuta la función al cambair el texto
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: "Buscar Evaluaciones...",                   // Texto de sugerencia en el campo
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
    );
  }
}
