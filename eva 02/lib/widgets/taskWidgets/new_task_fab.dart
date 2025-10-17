import 'package:app_tareas/widgets/taskWidgets/new_task_sheet.dart';
import 'package:flutter/material.dart';

class NewTaskFab extends StatelessWidget {                                            // Botón de acción flotante para nueva tarea
  const NewTaskFab({
    super.key,
    required this.onSubmit,
    this.onCreated,
    this.labelText = '',
    this.icon = Icons.add,
  });

  final void Function(String title, String? note, DateTime? due) onSubmit;          // Callback al enviar nueva tarea
  final void Function(BuildContext context)? onCreated;
  final String labelText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {                                              // Construcción del widget                    
    return FloatingActionButton.extended(
      icon: Icon(icon),
      label: Text(labelText),
      onPressed: () async {
        final localContext = context;                                                 // Captura el contexto antes del await

        final created = await showModalBottomSheet<bool>(                             // Mostrar hoja modal para nueva tarea
          context: localContext,
          isScrollControlled: true,                                                   // Permitir desplazamiento completo
          shape: const RoundedRectangleBorder(                                        // Forma redondeada en la parte superior
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),            // Radio de borde de 16
          ),
          builder: (ctx) => Padding(                                                  // Padding para evitar superposición con el teclado                     
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,                      // Ajuste dinámico según el teclado        
            ),
            child: NewTaskSheet(
              onSubmit: (title, note, due) {
                onSubmit(title, note, due);
                Navigator.pop(ctx, true);
              },
            ),
          ),
        );

       
        if ((created ?? false) && onCreated != null && localContext.mounted) {       // Verifica si el widget sigue montado antes de usar el contexto
          onCreated!(localContext);
        }
      },
    );
  }
}