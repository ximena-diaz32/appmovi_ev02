import 'package:app_tareas/models/task_filter.dart';

/// Configuración combinada de filtro de estado y orden de fecha
class TaskFilterConfig {
  final TaskFilter stateFilter;
  final bool ascending;

  const TaskFilterConfig({
    this.stateFilter = TaskFilter.all,
    this.ascending = true,
  });

  TaskFilterConfig copyWith({
    TaskFilter? stateFilter,
    bool? ascending,
  }) {
    return TaskFilterConfig(
      stateFilter: stateFilter ?? this.stateFilter,
      ascending: ascending ?? this.ascending,
    );
  }
}