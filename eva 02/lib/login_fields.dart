import 'package:app_tareas/task_memory.dart';
import 'package:app_tareas/task_screen.dart';
import 'package:flutter/material.dart';                                       // Importa las herramientas visuales de Flutter


class LoginFields extends StatefulWidget {                                    // Define un widget con estado (porque hay campos que cambian, como contraseña oculta o cargando)
  const LoginFields({super.key});                                             // Constructor del widget con clave opcional

  @override
  State<LoginFields> createState() => _LoginFieldsState();                    // Crea el estado del widget
}

class _LoginFieldsState extends State<LoginFields> {
  final _formKey =
      GlobalKey<FormState>();                                                // Llave para manejar el formulario y validaciones
  final _emailCtrl =
      TextEditingController();                                               // Controlador para el campo de email
  final _passCtrl =
      TextEditingController();                                               // Controlador para el campo de contraseña

  bool _obscure = true;                                                      // Para ocultar o mostrar la contraseña
  bool _loading =
      false;                                                                 // Para indicar si está cargando (ej. al enviar el formulario)
  String? _error;                                                            // Para guardar y mostrar un posible mensaje de error

  @override
  void dispose() {                                                           // Libera los recursos de los controladores cuando el widget se destruye    
   
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {                                             // Lógica para enviar el formulario
    
    FocusScope.of(context).unfocus();                                        // Oculta el teclado
    final ok = _formKey.currentState?.validate() ?? false;                   // Valida los campos
    if (!ok)return;                                                          //Si no es válido no continua

    setState(() {
      _loading =true;
      _error =null;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 8000));              // Simula una llamada de red (auth).

      if (!mounted) return;                                                  // Seguridad: evita usar context si el widget se removió.
      Navigator.of(context).pushReplacement(                                 // Reemplaza la pantalla actual por la de Tareas.
        MaterialPageRoute(builder: (_) => const TaskScreen()),               // Define la ruta a TasksScreen.
      );
    } catch (e) {                                                            // Si algo falla (ej. credenciales/red) entra aquí.
      if (!mounted) return;                                                  // Evita setState si el widget ya no existe.
      setState(() => _error = 'Credenciales inválidas o error de red');      // Guarda un mensaje de error global.
      ScaffoldMessenger.of(context).showSnackBar(                            // Muestra un SnackBar con feedback al usuario.
        const SnackBar(content: Text('No pudimos iniciar sesión')),
      );
    } finally {                                                              // Se ejecuta siempre (haya éxito o error).
      if (mounted) setState(() => _loading = false);                         // Apaga el modo cargando y re-habilita la UI.
    }
  }  

  @override
  Widget build(BuildContext context) {                                       // Construye la parte visual del widget
   
    return AutofillGroup(                                                    // Agrupa los campos para autocompletar 
      
      child: Form(
        key: _formKey,                                                       // Usa la llave definida antes para validar
        autovalidateMode: AutovalidateMode
            .onUserInteraction,                                              // Valida automáticamente mientras el usuario escribe
        child: Column(                                                       // Organiza los widgets en una columna
          
          crossAxisAlignment:
              CrossAxisAlignment.stretch,                                    // Ajusta el contenido horizontalmente
          mainAxisSize: MainAxisSize.min,                                    // Ocupa el mínimo espacio necesario
          children: [
            Center(
              // Centra la imagen
              child: Image.network(
                "https://i.ibb.co/wNNSGtSt/hill-valley.png",                 // Logo de HILL VALLEY
                height: 250,
                fit: BoxFit.contain,                                         // Ajusta la imagen sin recortarla
              ),
            ),
            const SizedBox(height: 16),                                       // Espacio vertical
            const Text(
              "BIENVENIDOS BULLDOGS",                                         // Mensaje de bienvenida
              style: TextStyle(
                color: Color.fromARGB(255, 31, 115,117),
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),                                                               // Estilo del texto
              textAlign: TextAlign.center,                                     // Centra el texto
            ),
          const SizedBox(height: 24),
            TextFormField(                                                     // Campo de texto para el email
              
              enabled:
                  !_loading,                                                   // Está deshabilitado si _loading es falso (esto parece un error lógico, debería ser !loading)
              controller: _emailCtrl,                                          // Controlador del campo
              keyboardType: TextInputType
                  .emailAddress,                                               // Tipo de teclado: correo electrónico
              textCapitalization:
                  TextCapitalization.none,                                     // No letra mayuscula automáticamente
              autocorrect: false,                                              // Autocorrector desactivado
              enableSuggestions: true,                                         // Permite sugerencias del teclado
              autofillHints: const [
                AutofillHints.email,                                           // Sugerencia para autocompletar email
              ], 
              decoration: const InputDecoration(
                labelText: "Email",                                            // Etiqueta del campo COrreo
                hintText: "ej: marty.mcfly@hillvalley.edu",                    // Texto de ayuda
                prefixIcon: Icon(Icons.email_outlined),                        // Ícono al inicio
                border: OutlineInputBorder(),                                  // Borde alrededor del campo
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return "Ingresa tu email";
                final emailOk = RegExp(r'^\S+@\S+\.\S+$').hasMatch(value);
                return emailOk ? null : "Email inválido";
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 12),

            TextFormField(                                                      //  Campo de texto para la contraseña
              enabled: !_loading,
              controller: _passCtrl,
              obscureText: _obscure,
              enableSuggestions: false,
              autocorrect: false,
              autofillHints: const [AutofillHints.password],                  //  Sugerencia para autocompletar contraseña
              decoration: InputDecoration(
                labelText: "Contraseña",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),       //  Cambia el estado de _obscure para mostrar u ocultar la contraseña 
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,        // Cambia el ícono según el estado
                  ),
                  tooltip: _obscure ? "Mostrar" : "Ocultar",                   //  Tooltip para accesibilidad
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return "Ingrese la contraseña";    // Nota del campo vacio
                if (v.length < 6) return "Mínimo 6 caracteres";                // Validacion de longitud mínima
                return null; //valida
              },
              textInputAction: TextInputAction.done,                           // Acción del botón "done" en el teclado
              onFieldSubmitted: (_) => _submit(),                              // Envía el formulario al presionar "done"
            ),
            const SizedBox(height: 8),

            if (_error != null)                                                // Si hay un error, mostrar el mensaje
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),                                        // Espacio vertical  
              
            SizedBox(                                                           // Botón para enviar el formulario
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 31, 115,117),
                  foregroundColor: Colors.white
                ),
                onPressed: _loading?null:_submit,
                child: _loading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ) :const Text("INGRESAR"),                                        // Texto del botón
              ),
            ),

             const SizedBox(height: 8),                                           // Espacio vertical
             TextButton(                                                          // Botón para recuperar la contraseña
              onPressed: _loading?null:(){Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TaskMemory()),);},
              child: const Text(
                "¿Olvidaste tu contraseña?",
                style: TextStyle(
                  color: Color.fromARGB(255, 31, 115,117),                      // Color para texto del botón de recuperación
                  fontWeight: FontWeight.w500,
                  fontSize: 16, 
             )
        ))],
        ),
      ),
    );
  }
}
