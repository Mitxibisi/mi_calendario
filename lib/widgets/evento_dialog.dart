import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../utils/color_picker.dart';

class EventoDialog extends StatefulWidget {
  final Evento? evento;
  final void Function(Evento evento) onSave;
  final VoidCallback? onDelete;

  const EventoDialog({this.evento, required this.onSave, this.onDelete, super.key});

  @override
  _EventoDialogState createState() => _EventoDialogState();
}

class _EventoDialogState extends State<EventoDialog> {
  late TextEditingController tituloController;
  late Color color;
  late String tipoJornada;
  late TextEditingController horaInicio, minutoInicio, horaFin, minutoFin;

  @override
  void initState() {
    super.initState();
    tituloController = TextEditingController(text: widget.evento?.titulo ?? '');
    color = widget.evento?.color ?? Colors.blue;
    tipoJornada = widget.evento?.tipoJornada ?? 'Mañana';
    horaInicio = TextEditingController(text: widget.evento?.horaInicio.toString() ?? '0');
    minutoInicio = TextEditingController(text: widget.evento?.minutoInicio.toString() ?? '0');
    horaFin = TextEditingController(text: widget.evento?.horaFin.toString() ?? '0');
    minutoFin = TextEditingController(text: widget.evento?.minutoFin.toString() ?? '0');
  }

  @override
  void dispose() {
    horaInicio.dispose();
    minutoInicio.dispose();
    horaFin.dispose();
    minutoFin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Evento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo de texto para el título
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 10),
            // Botón para seleccionar el color
            ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: color,),
              onPressed: () {
                // Abre el ColorPicker como popup
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Selecciona un color'),
                      content: SingleChildScrollView(
                        child: ColorPickerScreen(
                          onColorChanged: (Color selectedColor) {
                            setState(() {
                              color = selectedColor; // Actualiza el color
                            });
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Seleccionar Color'),
            ),
            const SizedBox(height: 20),
            // Selector de tipo de jornada
            DropdownButton<String>(
              value: tipoJornada,
              items: const [
                DropdownMenuItem(value: 'Mañana', child: Text("Mañana")),
                DropdownMenuItem(value: 'Tarde', child: Text("Tarde")),
                DropdownMenuItem(value: 'Partido', child: Text("Partido")),
                DropdownMenuItem(value: 'Vacio', child: Text("Vacío")),
              ],
              onChanged: (value) {
                setState(() {
                  tipoJornada = value!;
                });
              },
            ),
            
          if (tipoJornada != 'Vacio') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: horaInicio,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Hora inicio'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: minutoInicio,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Minuto inicio'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: horaFin,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Hora fin'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: minutoFin,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Minuto fin'),
                  ),
                ),
              ],
            ),
          ],
          ]
        ),
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: widget.onDelete,
            child: const Text('Eliminar'),
          ),
        TextButton(
          onPressed: () {
            final nuevoEvento = Evento(
              tituloController.text,
              color,
              tipoJornada,
              horaInicio: int.tryParse(horaInicio.text) ?? 0,
              minutoInicio: int.tryParse(minutoInicio.text) ?? 0,
              horaFin: int.tryParse(horaFin.text) ?? 0,
              minutoFin: int.tryParse(minutoFin.text) ?? 0,
            );
            widget.onSave(nuevoEvento);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}