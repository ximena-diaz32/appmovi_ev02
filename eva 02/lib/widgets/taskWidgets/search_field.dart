import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {                               // Campo de búsqueda
  const SearchField({super.key, required this.onChanged});               // Constructor con parámetro para cambios
  final ValueChanged<String> onChanged;                                  // Función que se ejecuta al cambiar el texto

  @override
  State<SearchField> createState() => _SearchFieldState();               // Crea el estado del widget
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode _focusNode = FocusNode();                             // Nodo de foco para controlar el cursor
  final TextEditingController _controller = TextEditingController();    // Controlador del campo de texto

  @override
  void dispose() {
    _focusNode.dispose();                                              // Libera el nodo de foco
    _controller.dispose();                                             // Libera el controlador
    super.dispose();
  }

  void _handleSubmitted(String value) {                                // Función que se ejecuta al presionar "Buscar"
    widget.onChanged(value);                                           // Ejecuta la función pasada como parámetro
    _focusNode.unfocus();                                              // Quita el foco del campo de texto
  }

  @override
  Widget build(BuildContext context) {                                // Método que construye el widget
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),              // Padding
      child: TextField(
        controller: _controller,                                      // Controlador del campo de texto
        focusNode: _focusNode,                                        // Nodo de foco
        onChanged: widget.onChanged,                                  // Función al cambiar el texto
        onSubmitted: _handleSubmitted,                                // Función al enviar el texto                              
        textInputAction: TextInputAction.search,                      // Acción del teclado
        decoration: const InputDecoration(
          hintText: "Buscar Evaluaciones...",                         // Texto de sugerencia en el campo
          prefixIcon: Icon(Icons.search),                             // Icono de búsqueda
          border: OutlineInputBorder(),                               // Borde del campo
          filled: true,                                               // Fondo relleno
        ),
      ),
    );
  }
}