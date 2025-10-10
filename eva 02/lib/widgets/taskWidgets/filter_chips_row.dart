import 'package:app_tareas/models/task_filter.dart';
import 'package:flutter/material.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.color,
  });

  final TaskFilter value;
  final ValueChanged<TaskFilter> onChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {                                   // Widget de pesañas de filtrado
    final active = color ?? Theme.of(context).colorScheme.primary;
    ChoiceChip chip(String label, TaskFilter filter) => ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: value == filter ? Colors.white : const Color.fromARGB(255, 31, 115,117)), 
                                                                        // Color de pestaña activa
      ),
      selected: value == filter,
      selectedColor: active,
      onSelected: (_) => onChanged(filter),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Wrap(
        spacing: 0,
        children: [
          chip("Todas", TaskFilter.all),                                // Pestaña Todas
          chip("Pendientes", TaskFilter.pending),                       // Pestaña Pendientes
          chip("Completada", TaskFilter.done),                          // Pestaña Completada
          chip("Vencidas", TaskFilter.overdueNotDone),                  // Pestaña Vencidas no rendidas
        ],
      ),
    );
  }
}
