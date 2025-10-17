import 'package:flutter/material.dart';
import 'package:app_tareas/models/task_filter.dart';
import 'package:app_tareas/models/task_filter_config.dart';

class FilterMenuButton extends StatelessWidget {                                        // Botón de menú de filtro de tareas                     
  const FilterMenuButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskFilterConfig value;                                                        // Configuración de filtro actual                    
  final ValueChanged<TaskFilterConfig> onChanged;

  @override
  Widget build(BuildContext context) {                                                 // Construcción del widget
    final isAsc = value.ascending;

    return PopupMenuButton<TaskFilter>(                                               // Botón de menú emergente                      
      tooltip: "Ordenar por fecha",                                                   // Opciones de ordenamiento por fecha                     
      initialValue: isAsc ? TaskFilter.dateAsc : TaskFilter.dateDesc,                 // Valor inicial según la configuración actual
      onSelected: (selected) {                                                        // Al seleccionar una opción de ordenamiento                     
        final ascending = selected == TaskFilter.dateAsc;                             // Determinar si es ascendente               
        onChanged(value.copyWith(ascending: ascending));                                            
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: TaskFilter.dateAsc, child: Text("Fecha Ascendente")),      // Opción de orden ascendente             
        PopupMenuItem(value: TaskFilter.dateDesc, child: Text("Fecha Descendente")),    // Opción de orden descendente
      ],
      icon: Transform.rotate(                                                           //  Icono del botón con rotación según el orden seleccionado
        angle: isAsc ? 3.1416 : 0,
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}