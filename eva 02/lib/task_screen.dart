import 'package:app_tareas/controller/task_controller.dart';
import 'package:app_tareas/utils/date_utils.dart';
import 'package:app_tareas/widgets/taskWidgets/empty_state.dart';
import 'package:app_tareas/widgets/taskWidgets/filter_chips_row.dart';
import 'package:app_tareas/widgets/taskWidgets/filter_menu_button.dart';
import 'package:app_tareas/widgets/taskWidgets/new_task_fab.dart';
import 'package:app_tareas/widgets/taskWidgets/search_field.dart';
import 'package:app_tareas/widgets/taskWidgets/task_list_view.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late final TaskController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TaskController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        final items = _ctrl.filtered;
        return Scaffold(
          appBar: AppBar(
            title: const Text("EVALUACIONES"),                                                        // Título de la pantalla
            centerTitle: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),                    // Estilo del título
            backgroundColor: const Color.fromARGB(255, 31, 115, 117),
            actions: [
              FilterMenuButton(value: _ctrl.filter, onChanged: _ctrl.setFilter),                      // Botón de menú para filtrar
            ],
          ),
          floatingActionButton: NewTaskFab(
            onSubmit: (title, note, due) => _ctrl.add(title, note: note, due: due),                   // Añade una nueva tarea
            onCreated: (ctx) => ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text("EVALUACIÓN AGENDADA"),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SearchField(onChanged: _ctrl.setQuery),
                FilterChipsRow(
                  value: _ctrl.filter,
                  onChanged: _ctrl.setFilter,
                  color: const Color.fromARGB(255, 31, 115, 117),
                ),
                const Divider(height: 1),
                Expanded(
                  child: items.isEmpty
                      ? const EmptyState()
                      : TaskListView(
                          items: items,
                          onToggle: (task, done) => _ctrl.toogle(task, done),                          //   Cambia el estado de completado de la tarea
                          onDelete: (task) {
                            final messenger = ScaffoldMessenger.of(context);
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('¿Eliminar "${task.title}"?',),                         // Mensaje de confirmación
                                duration: const Duration(seconds: 5),                                 // Duración del SnackBar        
                                backgroundColor: const Color.fromARGB(255, 31, 115, 117),
                                action: SnackBarAction(
                                  label: 'Confirmar',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    _ctrl.remove(task);
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "EVALUACIÓN ELIMINADA",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        backgroundColor: Color.fromARGB(255, 31, 115, 117),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          dateFormatter: formatShortDate,
                          swipeColor: const Color.fromARGB(255, 31, 115, 117),
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