import 'package:app_tareas/widgets/taskWidgets/new_task_sheet.dart';
import 'package:flutter/material.dart';

class NewTaskFab extends StatelessWidget {
  const NewTaskFab({
    super.key,
    required this.onSubmit,
    this.onCreated,
    this.labelText = '',
    this.icon = Icons.add,
  });

  final void Function(String title, String? note, DateTime? due) onSubmit;
  final void Function(BuildContext context)? onCreated;
  final String labelText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(icon),
      label: Text(labelText),
      onPressed: () async {
        final localContext = context; // Captura el contexto antes del await

        final created = await showModalBottomSheet<bool>(
          context: localContext,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: NewTaskSheet(
              onSubmit: (title, note, due) {
                onSubmit(title, note, due);
                Navigator.pop(ctx, true);
              },
            ),
          ),
        );

        // Verifica si el widget sigue montado antes de usar el contexto
        if ((created ?? false) && onCreated != null && localContext.mounted) {
          onCreated!(localContext);
        }
      },
    );
  }
}