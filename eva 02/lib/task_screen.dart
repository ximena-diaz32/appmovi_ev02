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

class TaskScreen extends StatefulWidget {                                                 // Pantalla principal de evaluaciones
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();                                  // Crear el estado del widget    
}

class _TaskScreenState extends State<TaskScreen> {                                        // Estado de la pantalla principal de evaluaciones              
  late final TaskController _ctrl;
  final ValueNotifier<Task?> _highlightedTask = ValueNotifier(null);

  @override
  void initState() {                                                                      // Inicialización del estado                 
    super.initState();
    _ctrl = TaskController();
  }

  @override
  void dispose() {                                                                        // Limpieza del estado
    _ctrl.dispose();
    _highlightedTask.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {                                                    // Construcción del widget            
    return AnimatedBuilder(                                                               // Reconstruir al cambiar el controlador
      animation: _ctrl,
      builder: (context, child) {
        final items = _ctrl.filtered;
        return Scaffold(                                                                  // Estructura principal de la pantalla                     
          appBar: AppBar(
            title: const Text("EVALUACIONES"),                                            // Título de la barra de navegación
            centerTitle: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
            backgroundColor: const Color.fromARGB(255, 31, 115, 117),
            actions: [
              FilterMenuButton(                                                           // Botón de menú de filtro                       
                value: _ctrl.filter,
                onChanged: (newConfig) {
                  _ctrl.setOrder(newConfig.ascending);
                },
              ),                                                                          
            ],
          ),                                                                             
          floatingActionButton: NewTaskFab(                                               //AppBar // Botón flotante para nueva evaluación                           
            onSubmit: (title, note, due) =>
                _ctrl.add(title, note: note, due: due),
            onCreated: (ctx) => ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(content: Text("EVALUACIÓN AGENDADA")),                       // Mensaje al crear una nueva evaluación
            ),
          ),
          body: SafeArea(                                                                 // Área segura para el contenido principal
            child: Column(
              children: [
                SearchField(onChanged: _ctrl.setQuery),
                FilterChipsRow(
                  value: _ctrl.filter,
                  onChanged: (config) => _ctrl.setStateFilter(config.stateFilter),
                  color: const Color.fromARGB(255, 31, 115, 117),                       // Color de los chips de filtro           
                ),
                const Divider(height: 1),
                Expanded(
                  child: items.isEmpty                                                    // Si no hay evaluaciones que mostrar
                      ? const EmptyState()
                      : ValueListenableBuilder<Task?>(
                          valueListenable: _highlightedTask,
                          builder: (context, highlighted, _) {
                            return TaskListView(                                          // Vista de lista de evaluaciones
                              items: items,
                              onToggle: (task, done) =>
                                  _ctrl.toggle(task, done),
                              onDelete: (task) {
                                final messenger =
                                    ScaffoldMessenger.of(context);                        // Mensajero para mostrar SnackBars
                                final index = _ctrl.filtered.indexOf(task);
                                final backup = Task(
                                  title: task.title,
                                  note: task.note,
                                  due: task.due,
                                  done: task.done,
                                );

                                _ctrl.remove(task);                                       // Eliminar la evaluación           

                                messenger.showSnackBar(
                                  SnackBar(                                               // SnackBar para deshacer eliminación
                                    duration: const Duration(seconds: 1955),              // Duración larga para permitir deshacer
                                    backgroundColor: const Color.fromARGB(              // Color de fondo del SnackBar
                                        255, 31, 115, 117),
                                    content: Row(
                                      children: [
                                        Expanded(
                                          child: Text(                                    // Texto de confirmación
                                            '¿Eliminar "${task.title}"?',
                                            style: const TextStyle(
                                                color: Colors.white,                    // Color del texto
                                                fontSize: 18),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            messenger.hideCurrentSnackBar();
                                            messenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "EVALUACIÓN ELIMINADA",                   // Confirmación de eliminación
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                backgroundColor: Color.fromARGB(          // Color de fondo del SnackBar
                                                    255, 31, 115, 117),
                                                duration: Duration(
                                                    milliseconds: 2000),                    // Duración del SnackBar                 
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Confirmar",                                    // Texto del botón de confirmación                 
                                            style: TextStyle(
                                                color: Colors.white,                      // Color del texto  
                                                fontSize: 16),
                                          ),
                                        ),
                                        TextButton(                                         // Botón para deshacer la eliminación                     
                                          onPressed: () {
                                            messenger.hideCurrentSnackBar();
                                            _ctrl.insertAt(index, backup);
                                            _highlightedTask.value = backup;
                                            messenger.showSnackBar(
                                              SnackBar(                                     // SnackBar de restauración de evaluación
                                                content: Text(
                                                  'EVALUACIÓN RESTAURADA: "${task.title}"', // Texto de restauración de evaluación
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                backgroundColor:                            // Color de fondo del SnackBar    
                                                    const Color.fromARGB(
                                                        255, 31, 115, 117),
                                                duration: const Duration(
                                                    milliseconds: 2000),                    // Duración del SnackBar
                                              ),
                                            );
                                            Future.delayed(                                 // Esperar antes de quitar el highlight  
                                                const Duration(
                                                    milliseconds: 600), () {                // Después de 600 ms
                                              if (mounted) {
                                                _highlightedTask.value = null;
                                              }
                                            });
                                          },
                                          child: const Text(
                                            "Deshacer",                                     // Texto del botón de deshacer                        
                                            style: TextStyle(
                                                color: Colors.white,                      // Color del texto                  
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              dateFormatter: formatShortDate,                               // Formateador de fecha corta
                              swipeColor:
                                  const Color.fromARGB(255, 31, 115, 117),                // Color del swipe de evaluación
                              highlight: highlighted,                                       // Evaluación resaltada
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