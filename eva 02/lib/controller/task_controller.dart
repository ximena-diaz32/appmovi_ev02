import 'package:flutter/material.dart';
import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/models/task_filter.dart';
import 'package:app_tareas/models/task_filter_config.dart';

class TaskController extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      title: "Física - ¿qué es la radiactividad?",
      note: "Entendiendo la emisión de energía en forma de radiación",
      due: DateTime.now().add(const Duration(days: -13)),
    ),
    Task(
      title: "Física aplicada",
      note: "Cálculos prácticos de masa, fuerza y aceleración",
      due: DateTime.now().add(const Duration(days: -5)),
      done: true,
    ),
    Task(
      title: "Taller de Cine",
      note: "Clint Eastwood, de actor a director",
      due: DateTime.now().add(const Duration(days: -3)),
      done: true,
    ),
    Task(
      title: "Ciencias Naturales",
      note: "La importancia del reciclaje y la generación de energías",
      due: DateTime.now().add(const Duration(days: -1)),
    ),
    Task(
      title: "Física Cuántica",
      note: "Las paradojas temporales, mito o realidad",
      due: DateTime.now().add(const Duration(days: 0)),
      done: true,   ),
    Task(
      title: "Música",
      note: "Chuck Berry, la guitarra del rock n' roll",
      due: DateTime.now().add(const Duration(days: 7)),
    ),
    Task(
      title: "Mecánica Básica",
      note: "Análisis y reparación de fallas en mecánica casera",
      due: DateTime.now().add(const Duration(days: 11)),
    ),
  ];

  String _query = "";
  TaskFilterConfig _filter = const TaskFilterConfig();                  // Todo y ascendente orden por defecto
  // Getters
  List<Task> get task => List.unmodifiable(_tasks);
  String get query => _query;
  TaskFilterConfig get filter => _filter;

  // Lista filtrada y ordenada
  List<Task> get filtered {
    final q = _query.trim().toLowerCase();

    final filteredList = _tasks.where((t) {
      final byState = switch (_filter.stateFilter) {
        TaskFilter.all => true,
        TaskFilter.pending => !t.done,
        TaskFilter.done => t.done,
        TaskFilter.overdueNotDone =>
            !t.done && t.due != null && t.due!.isBefore(DateTime.now()),
        TaskFilter.dateAsc => throw UnimplementedError(),
        TaskFilter.dateDesc => throw UnimplementedError(),
      };

      final byQuery = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          (t.note?.toLowerCase().contains(q) ?? false) ||
          (t.due != null &&
              t.due!.toIso8601String().toLowerCase().contains(q));

      return byState && byQuery;
    }).toList();

    filteredList.sort((a, b) {
      if (a.due == null && b.due == null) return 0;
      if (a.due == null) return 1;
      if (b.due == null) return -1;
      return _filter.ascending
          ? a.due!.compareTo(b.due!)
          : b.due!.compareTo(a.due!);
    });

    return filteredList;
  }

  // Acciones
  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setStateFilter(TaskFilter stateFilter) {
    _filter = _filter.copyWith(stateFilter: stateFilter);
    notifyListeners();
  }

  void setOrder(bool ascending) {
    _filter = _filter.copyWith(ascending: ascending);
    notifyListeners();
  }

  void toggle(Task task, bool done) {
    task.done = done;
    notifyListeners();
  }

  void add(String title, {String? note, DateTime? due}) {
    _tasks.insert(0, Task(title: title, note: note, due: due));
    notifyListeners();
  }

  void remove(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void insertAt(int index, Task task) {
    if (index < 0 || index > _tasks.length) {
      _tasks.add(task);
    } else {
      _tasks.insert(index, task);
    }
    notifyListeners();
  }
}