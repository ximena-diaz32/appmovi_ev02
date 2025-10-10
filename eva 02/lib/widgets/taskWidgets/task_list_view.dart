import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/widgets/taskWidgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatelessWidget {                                        // Lista de evaluaciones
  const TaskListView({
    super.key,
    required this.items,                                                            // Lista de evaluaciones
    required this.onToggle,                                                         // Función al cambiar el estado de la evaluación      
    required this.onDelete,                                                         // Función al eliminar la evaluación           
    required this.dateFormatter,                                                    // Función para formatear la fecha
    required this.swipeColor,                                                       // Color del swipe  
    this.empty,                                                                     // Widget a mostrar si la lista está vacía  
    this.itemKeyOf,                                                                 // Función para obtener la llave del item (opcional)   
  });

  final List<Task> items;                                                          // Lista de evaluaciones     
  final void Function(Task task, bool done) onToggle;                              // Función al cambiar el estado de la evaluación
  final void Function(Task task) onDelete;                                         // Función al eliminar la evaluación
  final String Function(DateTime) dateFormatter;                                   // Función para formatear la fecha
  final Color swipeColor;                                                          // Color del swipe

  final Widget? empty;                                                             // Widget a mostrar si la lista está vacía              

  final Object? Function(Task task)? itemKeyOf;                                    // Función para obtener la llave del item (opcional)        

  @override                                                                        // Sobrescribe el método build para construir el widget
  Widget build(BuildContext context) {
    if (items.isEmpty) return empty ?? const SizedBox.shrink();                   // Si la lista está vacía, mostrar el widget vacío o un SizedBox  

    return ListView.separated(                                                    // Lista separada de evaluaciones
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final task = items[i];
        return TaskCard(                
          task: task,
          itemKey: itemKeyOf?.call(task),
          dateText: task.due != null ? dateFormatter(task.due!) : null,             // Formatear la fecha si existe
          onToggle: (v) => onToggle(task, v),
          onDismissed: () => onDelete(task),
          swipeColor: swipeColor,
        );
      },
    );
  }
}
