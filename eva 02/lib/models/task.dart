
class Task {                                             // Modelo de tarea             
  String title;                                          // Título de la tarea 
  String? note;                                          // Nota opcional                        
  DateTime? due;                                         // Fecha de vencimiento opcional                     
  bool done;                                             // Estado de completitud                    
                                       

  Task({                                                  
    required this.title,                                 // Título de la tarea obligatorio
    this.note,                                           // Nota opcional
    this.due,                                            // Fecha de vencimiento opcional               
    this.done = false,                                   // Estado de completitud por defecto false   
    
  });
}



