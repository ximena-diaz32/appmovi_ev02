import 'package:flutter/material.dart';
import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/models/task_filter.dart';
import 'package:app_tareas/models/task_filter_config.dart';

class TaskController extends ChangeNotifier {                          
  final List<Task> _tasks = [
    Task(
      title: "Física - ¿qué es la radiactividad?",                        // Tareas de ejemplo
      note: "Entendiendo la emisión de energía en forma de radiación",
      due: DateTime.now().add(const Duration(days: -13)),
    ),
    Task(
      title: "Física aplicada",
      note: "Cálculos prácticos de masa, fuerza y aceleración",           // Tarea ya realizada     
      due: DateTime.now().add(const Duration(days: -5)),
      done: true,
    ),
    Task(
      title: "Taller de Cine",                                            // Tarea ya realizada
      note: "Clint Eastwood, de actor a director",
      due: DateTime.now().add(const Duration(days: -3)),
      done: true,
    ),
    Task(
      title: "Ciencias Naturales",
      note: "La importancia del reciclaje y la generación de energías",   // Tarea vencida
      due: DateTime.now().add(const Duration(days: -1)),
    ),
    Task(
      title: "Física Cuántica",
      note: "Las paradojas temporales, mito o realidad",                   // Tarea del día             
      due: DateTime.now().add(const Duration(days: 0)),
      done: true,   ),
    Task(
      title: "Música",
      note: "Chuck Berry, la guitarra del rock n' roll",                    // Tarea futura            
      due: DateTime.now().add(const Duration(days: 7)),
    ),
    Task(
      title: "Mecánica Básica",
      note: "Análisis y reparación de fallas en mecánica casera",           
      due: DateTime.now().add(const Duration(days: 11)),
    ),
  ];

  String _query = "";
  TaskFilterConfig _filter = const TaskFilterConfig();                      // Todo y ascendente orden por defecto
                                                                            
  List<Task> get task => List.unmodifiable(_tasks);                         // Lista inmodificable de tareas  
  String get query => _query;
  TaskFilterConfig get filter => _filter;

  
  List<Task> get filtered {                                                 // Lista de tareas filtradas
    final q = _query.trim().toLowerCase();

    final filteredList = _tasks.where((t) {                                 // Filtrado por estado y consulta
      final byState = switch (_filter.stateFilter) {                        // Filtrado por estado
        TaskFilter.all => true,                                             // Todas las tareas
        TaskFilter.pending =>                                               // Tareas pendientes             
        !t.done && t.due != null && t.due!.isAfter(DateTime.now()),                             
        TaskFilter.done => t.done,                                          // Tareas realizadas                         
        TaskFilter.overdueNotDone =>                                        // Tareas vencidas y no realizadas  
            !t.done && t.due != null && t.due!.isBefore(DateTime.now()),
        TaskFilter.dateAsc => throw UnimplementedError(),                   //  Filtro de orden ascendente por fecha (se usa en la ordenación)
        TaskFilter.dateDesc => throw UnimplementedError(),                  // Filtro de orden descendente por fecha  (se usa en la ordenación) 
      };

      final byQuery = q.isEmpty ||                                          // Filtrado por consulta de búsqueda
          t.title.toLowerCase().contains(q) ||                              // Título    
          (t.note?.toLowerCase().contains(q) ?? false) ||                   // Nota         
          (t.due != null &&                                                 // Fecha de vencimiento  
              t.due!.toIso8601String().toLowerCase().contains(q));              

      return byState && byQuery;
    }).toList();

    filteredList.sort((a, b) {                                              // Ordenación por fecha de vencimiento                        
      if (a.due == null && b.due == null) return 0;                         // Ambas sin fecha
      if (a.due == null) return 1;                                          // a sin fecha, b con fecha                    
      if (b.due == null) return -1;                                         // a con fecha, b sin fecha                     
      return _filter.ascending                                              // Ambas con fecha, ordenar según configuración
          ? a.due!.compareTo(b.due!)
          : b.due!.compareTo(a.due!);
    });

    return filteredList;
  }

  
  void setQuery(String value) {                                            // Actualizar consulta de búsqueda                         
    _query = value;
    notifyListeners();
  }

  void setStateFilter(TaskFilter stateFilter) {                            // Actualizar filtro de estado
    _filter = _filter.copyWith(stateFilter: stateFilter);
    notifyListeners();
  }

  void setOrder(bool ascending) {                                         // Actualizar orden de fecha                        
    _filter = _filter.copyWith(ascending: ascending);
    notifyListeners();
  }

  void toggle(Task task, bool done) {                                     // Alternar estado de tarea                 
    task.done = done;
    notifyListeners();
  }

  void add(String title, {String? note, DateTime? due}) {                  // Agregar nueva tarea             
    _tasks.insert(0, Task(title: title, note: note, due: due));
    notifyListeners();
  }

  void remove(Task task) {                                                 // Eliminar tarea                  
    _tasks.remove(task);
    notifyListeners();
  }

  void insertAt(int index, Task task) {                                    // Insertar tarea en posición específica                  
    if (index < 0 || index > _tasks.length) {
      _tasks.add(task);
    } else {
      _tasks.insert(index, task);
    }
    notifyListeners();
  }
}