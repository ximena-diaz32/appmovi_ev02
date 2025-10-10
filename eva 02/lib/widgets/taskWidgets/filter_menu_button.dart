import 'package:app_tareas/models/task_filter.dart';
import 'package:flutter/material.dart';

class FilterMenuButton extends StatelessWidget {                                  // Menu pop up de filtrado                   
  const FilterMenuButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskFilter value;
  final ValueChanged<TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskFilter>(
      tooltip: "Filtro",
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_) => const [
        PopupMenuItem(value: TaskFilter.all, child: Text("Todas")),                // Opción todas  
        PopupMenuItem(value: TaskFilter.pending, child: Text("Pendientes")),       // Opción Pendientes
        PopupMenuItem(value: TaskFilter.done, child: Text("Completada")),          // Opción Complatadas
        PopupMenuItem(value: TaskFilter.overdueNotDone, child: Text("Vencidas")),  // Opción vencidas no rendidas
      ],
      icon: const Icon(Icons.filter_list),
    );
  }
}
