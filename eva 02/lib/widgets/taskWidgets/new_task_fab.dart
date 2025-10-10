import 'package:app_tareas/widgets/taskWidgets/new_task_sheet.dart';
import 'package:flutter/material.dart';

class NewTaskFab extends StatelessWidget {
  const NewTaskFab({
    super.key,                                                      // Key opcional para identificar el widget en el árbol
    required this.onSubmit,                                         // Callback requerido: recibe (title, note, due)
    this.onCreated,                                                 // Callback opcional tras crear (p. ej., mostrar SnackBar)
    this.labelText = '',                                            // Texto por defecto del FAB
    this.icon = Icons.add,                                          // Ícono por defecto del FAB
  });

  final void Function(String title, String? note, DateTime? due)
  onSubmit;                                                          // Define parámetros a propagar
  final void Function(BuildContext context)?
  onCreated;                                                         // Callback opcional ejecutado si el sheet retorna éxito
  final String labelText;                                            // Texto visible en el FAB
  final IconData icon;                                               // Ícono visible en el FAB

  @override                                                          // Sobrescribe el método build para construir el widget

  Widget build(BuildContext context) {                               // Botón flotante con ícono y texto
    return FloatingActionButton.extended(
      icon: Icon(icon),                                              // Icono del botón
      label: Text(labelText),                                        // Etiqueta del botón
      onPressed: () async {                                          // Acción al presionar
        final created = await showModalBottomSheet(                  // Muestra un modal inferior y espera el resultado
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => Padding(                                   // Contenido con márgenes
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: NewTaskSheet(                                       // Formulario de nueva tarea
              onSubmit: (title, note, due) {                           // Al enviar el formulario
                onSubmit(title, note, due);                            // Ejecuta función externa
                Navigator.pop(ctx, true);                              // Cierra el modal con resultado
              },
            ),
          ),
        );
        if ((created ?? false) && onCreated != null) {                 // Si se creó la tarea y hay función de post-creación, se ejecuta
          onCreated!(context);
        }
      },
    );
  }
}
