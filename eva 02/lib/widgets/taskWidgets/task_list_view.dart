import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/widgets/taskWidgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({
    super.key,
    required this.items,
    required this.onToggle,
    required this.onDelete,
    required this.dateFormatter,
    required this.swipeColor,
    this.empty,
    this.itemKeyOf,
    this.highlight,
  });

  final List<Task> items;
  final void Function(Task task, bool done) onToggle;
  final void Function(Task task) onDelete;
  final String Function(DateTime) dateFormatter;
  final Color swipeColor;
  final Task? highlight;

  final Widget? empty;
  final Object? Function(Task task)? itemKeyOf;

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant TaskListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlight != null && widget.highlight != oldWidget.highlight) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return widget.empty ?? const SizedBox.shrink();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemCount: widget.items.length,
      itemBuilder: (context, i) {
        final task = widget.items[i];
        final isHighlighted = task == widget.highlight;

        final content = TaskCard(
          task: task,
          itemKey: widget.itemKeyOf?.call(task),
          dateText: task.due != null ? widget.dateFormatter(task.due!) : null,
          onToggle: (v) => widget.onToggle(task, v),
          onDismissed: () => widget.onDelete(task),
          swipeColor: widget.swipeColor,
        );

        if (isHighlighted) {
          return SlideTransition(
            position: _offsetAnimation,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 31, 115, 117,), // Color de fondo del highlight
                 
                ),
                child: content,
              ),
            ),
          );
        }

        return content;
      },
    );
  }
}
