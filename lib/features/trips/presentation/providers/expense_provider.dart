import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, ExpenseState>((ref) {
  final keyValueStorage = KeyValueStorageImpl();
  final tripRepository = TripRepositoryImpl();

  final tripNotifier = ref.watch(tripProvider.notifier);
  final userState = ref.watch(userProvider);

  return ExpenseNotifier(
    keyValueStorage: keyValueStorage,
    tripRepository: tripRepository,
    tripNotifier: tripNotifier,
    userState: userState,
  );
});

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  final KeyValueStorageServices keyValueStorage;
  final TripRepository tripRepository;

  final TripNotifier tripNotifier;
  final UserState userState;

  ExpenseNotifier({
    required this.keyValueStorage,
    required this.tripRepository,
    required this.tripNotifier,
    required this.userState,
  }) : super(ExpenseState());

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onAmountChanged(double amount) {
    state = state.copyWith(amount: amount);
  }

  void onDateChanged(DateTime date) {
    state = state.copyWith(date: date);
  }

  void onStatusChanged(String status) {
    state = state.copyWith(status: status);
  }

  void onCategoryChanged(int categoryId) {
    state = state.copyWith(categoryId: categoryId);
  }

  void validateForm() {
    final isValid = state.description.isNotEmpty &&
        state.amount > 0 &&
        state.date != null &&
        state.status.isNotEmpty;
    state = state.copyWith(isValid: isValid);
  }

  Expense? createObjectExpense() {
    try {
      final Expense expense = Expense(
        expenseDescription: state.description,
        expenseDate: state.date!,
        expenseStatus: state.status,
        categoryId: state.categoryId,
        expenseAmount: state.amount,
        tripId: tripNotifier.state.trip!.tripId,
        userId: userState.user!.userId,
      );
      return expense;
    } catch (e) {
      return null;
    }
  }

  Future? onFormSubmit( BuildContext context) async {
    state = state.copyWith(isPosting: true);
    validateForm();
    if (!state.isValid) {
      state = state.copyWith(isPosting: false);
      //TODO: Mostrar algun mensaje o algo
      return null;
    }
    try {
      final token = await keyValueStorage.getValue<String>('token');
      final Expense? expense = createObjectExpense();
      if (expense == null) {
        return null;
      }
      await tripRepository.addExpense(expense, token!);
      // await tripNotifier.getExpenses(tripNotifier.state.trip!.tripId);
      
      context.push('/wallet_screen');
    
    } catch (e) {
      //TODO: Mostrar algun mensaje o algo
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }

  
}

class ExpenseState {
  final bool isValid;
  final bool isPosting;

  final String description;
  final double amount;
  final DateTime? date;
  final String status;
  final int categoryId;

  ExpenseState({
    this.isPosting = false,
    this.isValid = false,
    this.description = '',
    this.amount = 0.0,
    this.date,
    this.status = '',
    this.categoryId = 0,
  });

  ExpenseState copyWith({
    bool? isValid,
    bool? isPosting,
    String? description,
    double? amount,
    DateTime? date,
    String? status,
    int? categoryId,
  }) =>
      ExpenseState(
        isValid: isValid ?? this.isValid,
        isPosting: isPosting ?? this.isPosting,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
      );
}
