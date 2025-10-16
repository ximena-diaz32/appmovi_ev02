import 'package:flutter/material.dart';
import 'package:app_tareas/models/task_filter.dart';
import 'package:app_tareas/models/task_filter_config.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.color,
  });

  final TaskFilterConfig value;
  final ValueChanged<TaskFilterConfig> onChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final active = color ?? Theme.of(context).colorScheme.primary;

    ChoiceChip chip(String label, TaskFilter filter) => ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: value.stateFilter == filter
              ? Colors.white
              : const Color.fromARGB(255, 31, 115, 117),
        ),
      ),
      selected: value.stateFilter == filter,
      selectedColor: active,
      onSelected: (_) => onChanged(value.copyWith(stateFilter: filter)),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Wrap(
        spacing: 0,
        children: [
          chip("Pendientes", TaskFilter.pending),
          chip("Completadas", TaskFilter.done),
          chip("Vencidas", TaskFilter.overdueNotDone),
          chip("Todas", TaskFilter.all),
        ],
      ),
    );
  }
}