import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart';
import 'package:nomad_app/features/trips/presentation/providers/expense_provider.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/shared/shared.dart';

class AddGastoScreen extends ConsumerStatefulWidget {
  const AddGastoScreen({super.key});

  @override
  ConsumerState<AddGastoScreen> createState() => _AddGastoScreen();
}

class _AddGastoScreen extends ConsumerState<AddGastoScreen> {
  Trip? trip;

  @override
  void initState() {
    super.initState();
    // Asignar la actividad si está disponible
    Future.microtask(() {
      final tripState = ref.read(tripProvider);
      if (tripState.trip != null) {
        setState(() {
          trip = tripState.trip;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/registro.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.6),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBackButton(context),
                      const Text(
                        "Agregar Gasto.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.attach_money, color: Colors.transparent),
                      ref.watch(expenseProvider).isEditing 
                        ? IconButton(
                            onPressed: () => ref.watch(expenseProvider.notifier).deleteExpense(context),
                            icon: const Icon(Icons.delete, color: Colors.white),
                          )  
                        : const Icon(Icons.attach_money, color: Colors.transparent),
                    ],
                  ),
                ),
                const SizedBox(height: 10), // Espacio debajo del título fijo
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.027),
                              CustomTextFormFieldGasto(
                                initialValue: ref.watch(expenseProvider).description,
                                hint: "Descripcion",
                                obscureText: false,
                                icon: Icons.description,
                                onChanged: (value) => ref.read(expenseProvider.notifier).onDescriptionChanged(value),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.027),
                              CustomTextFormFieldGasto(
                                initialValue: ref.watch(expenseProvider).amount == 0.0 ? '' : ref.watch(expenseProvider).amount.toString(),
                                hint: "Monto",
                                obscureText: false,
                                icon: Icons.description,
                                keyboardType: TextInputType.number,
                                onChanged: (value) => ref.read(expenseProvider.notifier).onAmountChanged(double.tryParse(value) ?? 0.0),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.027),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.width * 0.12,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: const CustomSearchStatusDD(
                                  options: ['Pagado', 'Pendiente'],
                                  texto: 'Selecciona un estado',
                                  color: Color.fromRGBO(51, 101, 138, 1),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.020),
                              Expanded(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  child: DateTimePicker(
                                    hintText: "Fecha Realizado",
                                    onDateChanged: (value) {
                                      final parsedDate = DateFormat('dd/MM/yyyy').parse(value);
                                      ref.read(expenseProvider.notifier).onDateChanged(parsedDate);
                                    },
                                    firstDate: DateTime.now().subtract(const Duration(days: 200)),
                                    lastDate: DateTime.now().add(const Duration(days: 730)),
                                  ),
                                ),
                              ),
                              CustomFilledButton(
                                text: "Añadir",
                                onPressed: () async {
                                  ref.read(expenseProvider.notifier).onFormSubmit(context);
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.030),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: ref.watch(expenseProvider).isPosting,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          context.go('/wallet_screen');
        },
      ),
    );
  }
}