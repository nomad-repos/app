import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart'; // Asegúrate de tener el modelo de `Event`.

class CreateEventScreen extends ConsumerStatefulWidget {

  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {

    @override
  void initState() {
    super.initState();
    
    // Leer el valor inicial sin reactividad
    final isEditing = ref.read(createEventProvider).isEditing;

    if (isEditing) {
      Future.microtask(() => ref.read(createEventProvider.notifier).loadEventForEdit());
    } else {
      Future.microtask(() => ref.read(createEventProvider.notifier).onDateChanged(
        HttpDate.parse(ref.read(tripProvider).trip!.tripStartDate) // Cambié aquí también a `ref.read`
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/iniciarsesion.jpg',  // Tu imagen de fondo
              fit: BoxFit.cover,
            ),
          ),
          // Contenedor blanco sobre la imagen con desplazamiento
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 20),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Crear Evento', // O "Editar Evento" según la situación
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Divider(),  

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text(
                                ref.watch(createEventProvider.notifier).getFormattedDate(), 
                                style: 
                                const TextStyle(fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3, 
                        child: CalendarDatePicker(
                          initialDate: trip.daySelected ?? HttpDate.parse(trip.trip!.tripStartDate),
                          firstDate: HttpDate.parse(trip.trip!.tripStartDate),
                          lastDate: HttpDate.parse(trip.trip!.tripFinishDate),
                          onDateChanged: (date) => ref.read(createEventProvider.notifier).onDateChanged(date),
                        ),
                      ),

                      const Divider(),

                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: const Icon(Icons.watch_later_outlined, color: Colors.grey),
                              title: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: ref.watch(createEventProvider).startTime == null 
                                    ? 'Inicio' 
                                    : "${ref.watch(createEventProvider).startTime!.hour}:${ref.watch(createEventProvider).startTime!.minute}",
                                  hintStyle: ref.watch(createEventProvider).startTime == null 
                                    ? const TextStyle(color: Colors.grey) 
                                    : const TextStyle(color: Colors.black),
                                  border: InputBorder.none,
                                ),
                              ),
                              onTap: () => showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((time) {
                                if (time != null) {
                                  ref.read(createEventProvider.notifier).onStartTimeChanged(time);
                                }
                              }),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ListTile(
                              leading: const Icon(Icons.watch_later, color: Colors.grey),
                              title: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: ref.watch(createEventProvider).endTime == null 
                                    ? 'Fin' 
                                    : "${ref.watch(createEventProvider).endTime!.hour}:${ref.watch(createEventProvider).endTime!.minute}",
                                  hintStyle: ref.watch(createEventProvider).endTime == null 
                                    ? const TextStyle(color: Colors.grey) 
                                    : const TextStyle(color: Colors.black),
                                  border: InputBorder.none,
                                ),
                              ),
                              onTap: () {
                                final startTime = ref.watch(createEventProvider).startTime;
                                if (startTime != null) {
                                  showTimePicker(
                                    context: context,
                                    initialTime: startTime,
                                  ).then((time) {
                                    if (time != null) {
                                      ref.read(createEventProvider.notifier).onEndTimeChanged(time);
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      ListTile(
                        leading: const Icon(Icons.description, color: Colors.grey),
                        title: TextFormField(
                          decoration: InputDecoration(
                            hintText: ref.watch(createEventProvider).name.isEmpty 
                              ? 'Nombre del evento' 
                              : ref.watch(createEventProvider).name,
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          onChanged: (name) => ref.read(createEventProvider.notifier).onNameChanged(name),
                        ),
                      ),

                      const Divider(),  
                      
                      ListTile(
                        leading: const Icon(Icons.description, color: Colors.grey),
                        title: TextFormField(
                          decoration: InputDecoration(
                            hintText: ref.watch(createEventProvider).description.isEmpty 
                              ? 'Descripción' 
                              : ref.watch(createEventProvider).description,
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          onChanged: (description) => ref.read(createEventProvider.notifier).onDescriptionChanged(description),
                        ),
                      ),
                      
                      const Divider(),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('¿Desea cancelar?', textAlign: TextAlign.center),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Continuar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(createEventProvider.notifier).createEvent(context);
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}