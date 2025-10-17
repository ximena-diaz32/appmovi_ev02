import 'package:app_tareas/models/task_filter.dart';


class TaskFilterConfig {                                    // Configuración combinada de filtro de estado y orden de fecha
  final TaskFilter stateFilter;
  final bool ascending;                                     // true: ascendente, false: descendente

  const TaskFilterConfig({                                  // Valores predeterminados
    this.stateFilter = TaskFilter.all,
    this.ascending = true,
  });

  TaskFilterConfig copyWith({                               // Método para copiar con modificaciones                  
    TaskFilter? stateFilter,
    bool? ascending,
  }) {
    return TaskFilterConfig(                                // Crear nueva instancia con valores modificados o existentes
      stateFilter: stateFilter ?? this.stateFilter,
      ascending: ascending ?? this.ascending,
    );
  }
}