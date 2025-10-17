// Importa el paquete de Flutter con widgets Material

import 'package:app_tareas/utils/date_utils.dart';
import 'package:flutter/material.dart';

// Widget de formulario para crear una nueva tarea
class NewTaskSheet extends StatefulWidget {
  const NewTaskSheet({
    super.key,                                                      // Key opcional para identificar el widget
    required this.onSubmit,                                         // Callback final que recibe (title, note, due)
    this.initialTitle = '',                                         // Título inicial (útil para editar)
    this.initialNote,                                               // Nota inicial (útil para editar)
    this.initialDue,                                                // Fecha inicial (útil para editar)
    this.submitLabel =
        'Agendar',                                                  // Texto del botón principal (p. ej. "Crear"/"Guardar")
    this.titleText =
        'Nueva Evaluación',                                         // Título del formulario mostrado en la cabecera
  });

  final void Function(String title, String? note, DateTime? due)
  onSubmit;                                                         // Firma del callback de envío
  final String initialTitle;                                        // Valor inicial del campo título
  final String? initialNote;                                        // Valor inicial del campo nota
  final DateTime? initialDue;                                       // Valor inicial del campo fecha
  final String submitLabel;                                         // Texto del botón de acción
  final String titleText;

  @override
  State<NewTaskSheet> createState() => _NewTaskSheetState();
}


class _NewTaskSheetState extends State<NewTaskSheet> {              // Estado del formulario de nueva tarea
  final _formKey = GlobalKey<FormState>();                          // Llave global para validar el formulario
  late final TextEditingController _titleCtrl;                      // Controlador para el campo de título
  late final TextEditingController _noteCtrl;                       // Controlador para el campo de notas
  final _titleFocus = FocusNode();
  final _noteFocus = FocusNode();

  DateTime? _due;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle);
    _noteCtrl = TextEditingController(text: widget.initialNote ?? "");
    _due = widget.initialDue;
  }

  Future<void> _pickDueDate() async {                                // Función para seleccionar la fecha de vencimiento     
    final now = DateTime.now();                                      // Fecha actual
    final picked = await showDatePicker(                             // Muestra el selector de fecha
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
      helpText: "Seleccione fecha de Evaluación",
      cancelText: "Cancelar",
      confirmText: "Aceptar",
    );
    if (picked != null) {
      setState(() {
        _due = DateTime(picked.year, picked.month, picked.day, 23, 59);   // Establece la fecha seleccionada a las 23:59 del día elegido
      });
    }
  }

  @override
  void dispose() {                                                  // Libera la memoria de los controladores cuando se destruye el widget
    _titleCtrl.dispose();                                         
    _noteCtrl.dispose();
    _noteFocus.dispose(); 
    _titleFocus.dispose(); 
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleCtrl.text.trim();
    final note = _noteCtrl.text.trim();
    widget.onSubmit(title, note.isEmpty ? null : note, _due);
  }

  @override
  Widget build(BuildContext context) {                               // Widget que representa el formulario
    
    return Form(
      key: _formKey,                                                 // Asocia la clave al formulario
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                     
        children: [                                                  // Se ajusta al contenido
                                                                     
          Text(                                                      // Título del formulario
            widget.titleText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),                                // Espacio vertical
                                                                     
          TextFormField(                                             // Campo para ingresar el título de la tarea
            controller: _titleCtrl,                                  // Conecta al controlador de título
            autofocus: true,                                         // Abre el teclado automáticamente
            focusNode: _titleFocus,
            textInputAction: TextInputAction.next,                   // Botón "siguiente"
            decoration: const InputDecoration(
              labelText: 'Evaluación',                               // Etiqueta visible
              hintText: 'Ej: Primera Evaluación',                    // Texto de ayuda
              prefixIcon: Icon(Icons.title),                         // Icono a la izquierda
              border: OutlineInputBorder(),                          // Borde cuadrado
              filled: true,                                          // Fondo con color
            ),
                                                                     // Valida que el título no esté vacío
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ingrese una Evaluación' : null,
          ),
          const SizedBox(height: 12),
        
          TextFormField(                                             // Campo para ingresar notas opcionales
            controller: _noteCtrl,                                   // Conecta al controlador de notas
            focusNode: _noteFocus,
            maxLines: 3,                                             // Permite varias líneas
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: const InputDecoration(
              labelText: 'Contenidos (Opcional)',                    // Etiqueta visible
              prefixIcon: Icon(Icons.note_outlined),                 // Icono de nota
              border: OutlineInputBorder(),
              filled: true,
            ),
          ),
          const SizedBox(height: 16),

          InkWell(                                                  // Campo interactivo para seleccionar la fecha de vencimiento
            onTap: _pickDueDate,
            borderRadius: const BorderRadius.all(Radius.circular(12)),    
            child: InputDecorator(
              decoration: const InputDecoration(                    // Decoración del campo            
                labelText: "Fecha de Rendición (Opcional)",
                border: OutlineInputBorder(),
                filled: true,
              ),
              child: Row(                                           // Fila con icono, fecha y botones
                children: [
                  const Icon(Icons.event),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(                                    // Muestra la fecha seleccionada o "Sin Fecha"
                      _due == null ? "Sin Fecha" : formatShortDate(_due!),
                    ),
                  ),
                  if (_due != null)
                    TextButton.icon(                                // Botón para quitar la fecha seleccionada                 
                      onPressed: () => setState(() => _due = null),
                      icon: const Icon(Icons.close),
                      label: const Text("Quitar"),
                    ),
                  TextButton.icon(                                  // Botón para elegir o cambiar la fecha de vencimiento
                    onPressed: _pickDueDate,
                    icon: const Icon(Icons.edit_calendar),
                    label: Text(_due == null ? "Elegir" : "Cambiar"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Botón para crear la tarea
          SizedBox(
            height: 48,
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color.fromARGB(255, 31, 115,117),  // Color de fondo
                  onPrimary: Colors.white,                          // Color del texto e ícono
                ),
              ),
              child: FilledButton.icon(                               // Botón principal para enviar el formulario             
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: Text(widget.submitLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
