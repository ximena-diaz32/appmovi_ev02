import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/widgets/taskWidgets/swipe_bg.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {                                             // Tarjeta de evaluación
  const TaskCard({                                                                   // Constructor
    super.key,
    required this.task,                                                              // Evaluación
    required this.onToggle,                                                          // Función al cambiar el estado de la evaluación
    required this.onDismissed,                                                       // Función al eliminar la evaluación
    required this.swipeColor,                                                        // Color del swipe
    this.dateText,                                                                   // Texto de la fecha
    this.itemKey,                                                                    // Llave del item (opcional)
  });

  final Task task;                                                                   // Evaluación
  final ValueChanged<bool> onToggle;                                                 // Función al cambiar el estado de la evaluación
  final VoidCallback onDismissed;                                                    // Función al eliminar la evaluación
  final Color swipeColor;                                                            // Color del swipe
  final String? dateText;                                                            // Texto de la fecha (opcional)
  final Object? itemKey;                                                             // Llave del item (opcional)

  @override
  Widget build(BuildContext context) {
    final k = itemKey ?? '${task.title}-${task.hashCode}';
    return Dismissible(
      key: ValueKey(k),
      background: SwipeBg(alineacion: Alignment.centerLeft, color: swipeColor),      // Fondo al deslizar
      secondaryBackground: SwipeBg(
        alineacion: Alignment.centerRight,
        color: swipeColor,
      ),
      onDismissed: (_) => onDismissed(),                                             // Llamar a la función al eliminar la evaluación             
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: CheckboxListTile(
          value: task.done,
          onChanged: (v) => onToggle(v ?? false),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,              // Tachado si está completada
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.note != null && task.note!.isNotEmpty)                         // Nota de la evaluación
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(task.note!),
                ),

              if (dateText != null)                                                   // Fecha de rendición
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.event, size: 16),
                      const SizedBox(width: 6),
                      Text(dateText!),
                    ],
                  ),
                ),
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,                           // Checkbox a la izquierda               
          secondary: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}