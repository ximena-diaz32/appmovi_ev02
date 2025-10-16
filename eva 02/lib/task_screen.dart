import 'package:flutter/material.dart';
import 'package:app_tareas/controller/task_controller.dart';
import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/utils/date_utils.dart';
import 'package:app_tareas/widgets/taskWidgets/empty_state.dart';
import 'package:app_tareas/widgets/taskWidgets/filter_chips_row.dart';
import 'package:app_tareas/widgets/taskWidgets/filter_menu_button.dart';
import 'package:app_tareas/widgets/taskWidgets/new_task_fab.dart';
import 'package:app_tareas/widgets/taskWidgets/search_field.dart';
import 'package:app_tareas/widgets/taskWidgets/task_list_view.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late final TaskController _ctrl;
  final ValueNotifier<Task?> _highlightedTask = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _ctrl = TaskController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _highlightedTask.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final items = _ctrl.filtered;
        return Scaffold(
          appBar: AppBar(
            title: const Text("EVALUACIONES"),
            centerTitle: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
            backgroundColor: const Color.fromARGB(255, 31, 115, 117),
            actions: [
              FilterMenuButton(
                value: _ctrl.filter,
                onChanged: (newConfig) {
                  _ctrl.setOrder(newConfig.ascending);
                },
              ),
            ],
          ),
          floatingActionButton: NewTaskFab(
            onSubmit: (title, note, due) =>
                _ctrl.add(title, note: note, due: due),
            onCreated: (ctx) => ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(content: Text("EVALUACIÓN AGENDADA")),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SearchField(onChanged: _ctrl.setQuery),
                FilterChipsRow(
                  value: _ctrl.filter,
                  onChanged: (config) => _ctrl.setStateFilter(config.stateFilter),
                  color: const Color.fromARGB(255, 31, 115, 117),
                ),
                const Divider(height: 1),
                Expanded(
                  child: items.isEmpty
                      ? const EmptyState()
                      : ValueListenableBuilder<Task?>(
                          valueListenable: _highlightedTask,
                          builder: (context, highlighted, _) {
                            return TaskListView(
                              items: items,
                              onToggle: (task, done) =>
                                  _ctrl.toggle(task, done),
                              onDelete: (task) {
                                final messenger =
                                    ScaffoldMessenger.of(context);
                                final index = _ctrl.filtered.indexOf(task);
                                final backup = Task(
                                  title: task.title,
                                  note: task.note,
                                  due: task.due,
                                  valuation: task.valuation,
                                  done: task.done,
                                );

                                _ctrl.remove(task);

                                messenger.showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 1955),
                                    backgroundColor: const Color.fromARGB(
                                        255, 31, 115, 117),
                                    content: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '¿Eliminar "${task.title}"?',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            messenger.hideCurrentSnackBar();
                                            messenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "EVALUACIÓN ELIMINADA",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                backgroundColor: Color.fromARGB(
                                                    255, 31, 115, 117),
                                                duration: Duration(
                                                    milliseconds: 3000),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Confirmar",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            messenger.hideCurrentSnackBar();
                                            _ctrl.insertAt(index, backup);
                                            _highlightedTask.value = backup;
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'EVALUACIÓN RESTAURADA: "${task.title}"',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 31, 115, 117),
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                              ),
                                            );
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 600), () {
                                              if (mounted) {
                                                _highlightedTask.value = null;
                                              }
                                            });
                                          },
                                          child: const Text(
                                            "Deshacer",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              dateFormatter: formatShortDate,
                              swipeColor:
                                  const Color.fromARGB(255, 31, 115, 117),
                              highlight: highlighted,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}