import 'package:flutter/material.dart';
import 'package:app_tareas/models/task_filter.dart';
import 'package:app_tareas/models/task_filter_config.dart';

class FilterChipsRow extends StatelessWidget {                                     // Fila de chips de filtro de tareas          
  const FilterChipsRow({
    super.key,
    required this.value,                                                           // Configuración de filtro actual
    required this.onChanged,                                                       // Callback al cambiar el filtro                     
    this.color,
  });

  final TaskFilterConfig value;                                                   // Configuración de filtro actual                   
  final ValueChanged<TaskFilterConfig> onChanged;                                 // Callback al cambiar el filtro  
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final active = color ?? Theme.of(context).colorScheme.primary;

    ChoiceChip chip(String label, TaskFilter filter) => ChoiceChip(               // Chip de opción individual
      label: Text(                                                                       
        label,
        style: TextStyle(
          color: value.stateFilter == filter
              ? Colors.white                                                   // Color de texto si está seleccionado
              : const Color.fromARGB(255, 31, 115, 117),                       // Color de texto si no está seleccionado              
        ),
      ),
      selected: value.stateFilter == filter,                                     // Estado seleccionado                 
      selectedColor: active,                                                     // Color de fondo si está seleccionado
      onSelected: (_) => onChanged(value.copyWith(stateFilter: filter)),         // Callback al seleccionar el chip 
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),                         // Padding alrededor de la fila de chips                   
      child: Wrap(
        spacing: 0,
        children: [
          chip("Pendientes", TaskFilter.pending),                               // Chip de tareas pendientes                   
          chip("Completadas", TaskFilter.done),                                 // Chip de tareas completadas
          chip("Vencidas", TaskFilter.overdueNotDone),                          // Chip de tareas vencidas no completadas                  
          chip("Todas", TaskFilter.all),                                        // Chip de todas las tareas
        ],
      ),
    );
  }
}