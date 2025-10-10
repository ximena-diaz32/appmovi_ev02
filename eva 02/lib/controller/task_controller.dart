import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/models/task_filter.dart';
import 'package:flutter/material.dart';

class TaskController extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      title: "Física - ¿que es la radiactividad?",
      note: "Entendiendo la emisión de energía en forma de radiación",
      due: DateTime.now().add(const Duration(days: -13)),
    ),
    Task(
      title: "Fisica aplicada",
      note: "calculos practicos de masa, fuerza y aclereración",
      due: DateTime.now().add(const Duration(days: -5)),
    ),
    Task(
      title: "Taller de Cine",
      valuation: 5.5,
      note: "Clint Eastwood, de actor a director",
      due: DateTime.now().add(const Duration(days: 3)),
      done: true,
    ),
    Task(
      title: "Ciencias Naturales",
      valuation: 6.5,
      note: "La importancia del reciclaje y la generaión de energías",
      due: DateTime.now().add(const Duration(days: 0)),
      done: true,
    ),
    Task(
      title: "Fisica Cuantica",
      note: "Las paradoja temporales, mito o realidad",
      due: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      title: "Música",
      note: "Chuck Berry, la guitarra del rock n Roll",
      due: DateTime.now().add(const Duration(days: 7)),
    ),
    Task(
      title: "Mecanica Básica",
      note: "Análisis y reparación de fallas en mecanica casera",
      due: DateTime.now().add(const Duration(days: 11)),
    ),
  ];

  String _query = "";
  TaskFilter _filter = TaskFilter.all;
  bool _ascendingOrder = true; // Orden ascendente por defecto

  List<Task> get task => List.unmodifiable(_tasks);
  String get query => _query;
  TaskFilter get filter => _filter;
  bool get ascendingOrder => _ascendingOrder;

  void toggleOrder() {
    _ascendingOrder = !_ascendingOrder;
    notifyListeners();
  }

  List<Task> get filtered {
    final q = _query.trim().toLowerCase();

    // Filtrar por estado y búsqueda
    final filteredList = _tasks.where((t) {
      final byFilter = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.pending => !t.done,
        TaskFilter.done => t.done,
        TaskFilter.overdueNotDone =>
          !t.done && t.due != null && t.due!.isBefore(DateTime.now()),
      };

      final byQuery =
          q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          (t.note?.toLowerCase().contains(q) ?? false);

      return byFilter && byQuery;
    }).toList();

    // Ordenar por fecha según el estado de _ascendingOrder
    filteredList.sort((a, b) {
      if (a.due == null && b.due == null) return 0;
      if (a.due == null) return 1;
      if (b.due == null) return -1;
      return _ascendingOrder
          ? a.due!.compareTo(b.due!)
          : b.due!.compareTo(a.due!);
    });

    return filteredList;
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void toogle(Task task, bool done) {
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
}