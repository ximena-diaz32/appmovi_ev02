import 'package:flutter/material.dart';
import 'package:app_tareas/models/task_filter.dart';
import 'package:app_tareas/models/task_filter_config.dart';

class FilterMenuButton extends StatelessWidget {
  const FilterMenuButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskFilterConfig value;
  final ValueChanged<TaskFilterConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    final isAsc = value.ascending;

    return PopupMenuButton<TaskFilter>(
      tooltip: "Ordenar por fecha",
      initialValue: isAsc ? TaskFilter.dateAsc : TaskFilter.dateDesc,
      onSelected: (selected) {
        final ascending = selected == TaskFilter.dateAsc;
        onChanged(value.copyWith(ascending: ascending));
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: TaskFilter.dateAsc, child: Text("Fecha Ascendente")),
        PopupMenuItem(value: TaskFilter.dateDesc, child: Text("Fecha Descendente")),
      ],
      icon: Transform.rotate(
        angle: isAsc ? 3.1416 : 0,
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}