import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/helpers/utils.dart';
import 'package:nomad_app/shared/utils/utils.dart'; // Asegúrate de tener el modelo de `Event`.

class CreateEventScreen extends ConsumerStatefulWidget {

  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {

    @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(createEventProvider.notifier).onDateChanged(
      DateTime.parse(ref.read(tripProvider).trip!.tripStartDate) // Cambié aquí también a `ref.read`
    ));
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider);

    ref.listen(errorTripProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        showSnackbar(context, next.errorMessage, Colors.red);
      }
    });

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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ref.watch(createEventProvider).isEditing 
                              ? "Editar evento"
                              : "Crear evento",
                            style: const TextStyle(
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
                                getFormattedDate(ref.watch(createEventProvider).date),
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
                          initialDate: trip.daySelected == null 
                            ? DateTime.parse(trip.trip!.tripStartDate).isBefore(DateTime.now()) 
                              ? DateTime.now() 
                              : DateTime.parse(trip.trip!.tripStartDate)
                            : trip.daySelected!.isBefore(DateTime.parse(trip.trip!.tripStartDate)) 
                              ? DateTime.parse(trip.trip!.tripStartDate) 
                              : trip.daySelected!, 
                          firstDate: DateTime.parse(trip.trip!.tripStartDate).isBefore(DateTime.now()) 
                            ? DateTime.now() 
                            : DateTime.parse(trip.trip!.tripStartDate),
                          lastDate: DateTime.parse(trip.trip!.tripFinishDate),
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
                                    : formatTimeOfDay(ref.watch(createEventProvider).startTime),
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
                                    : formatTimeOfDay(ref.watch(createEventProvider).endTime),
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
                          decoration: const InputDecoration(
                            hintText:'Nombre del evento',  
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          initialValue: ref.watch(createEventProvider).name.isEmpty 
                            ? null 
                            : ref.watch(createEventProvider).name,
                          onChanged: (name) => ref.read(createEventProvider.notifier).onNameChanged(name),
                        ),
                      ),

                      const Divider(),  
                      
                      ListTile(
                        leading: const Icon(Icons.description, color: Colors.grey),
                        title: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Descripción',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          initialValue: ref.watch(createEventProvider).description.isEmpty 
                            ? null 
                            : ref.watch(createEventProvider).description,
                          onChanged: (description) => ref.read(createEventProvider.notifier).onDescriptionChanged(description),
                        ),
                      ),
                      
                      const Divider(),
                      
                      GestureDetector(
                        onTap: () {
                          context.push('/map_activity_screen');
                        },
                        child: ListTile(
                          leading: const Icon(Icons.place, color: Colors.grey),
                          title: TextFormField(
                            decoration: InputDecoration(
                              hintText: ref.watch(createEventProvider).isEditing 
                                ? ref.watch(createEventProvider).event!.activity!.activityName
                                : ref.watch(createEventProvider).activity == null 
                                  ? 'Actividad' 
                                  : ref.watch(createEventProvider).activity!.activityName,
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            readOnly: true,
                          ),
                        ),
                      ),

                      const Divider(),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();

                              ref.watch(createEventProvider).isEditing
                                ? ref.read(createEventProvider.notifier).updateEvent(context)
                                : ref.read(createEventProvider.notifier).createEvent(context);
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

          Visibility(
            visible: ref.watch(createEventProvider).isPosting,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ),
        ],
      ),
    );
  }
}