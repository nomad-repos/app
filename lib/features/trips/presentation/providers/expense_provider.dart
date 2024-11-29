
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
  }) : super(ExpenseState()){
    getExpenses();
  }

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
        categoryId: 1, // Esto no debe ir asi
        expenseAmount: state.amount,
        expenseId: state.expenseIdEditing,
        tripId: tripNotifier.state.trip!.tripId,
        userId: userState.user!.userId,
      );
      return expense;
    } catch (e) {
      return null;
    }
  }

  Future onFormSubmit( BuildContext context) async {
    print(state.isEditing);
    state = state.copyWith(isPosting: true);
    validateForm();
    if (!state.isValid) {
      showSnackbar(context, 'Formulario inválido', Colors.red);
      state = state.copyWith(isPosting: false); 
      return null;
    }

    
    if (!state.isEditing) {
      try {
        final token = await keyValueStorage.getValue<String>('token');
        final Expense? expense = createObjectExpense();
        if (expense == null) {
          return null;
        }
        await tripRepository.addExpense(expense, token!);
        await getExpenses();
        
        context.push('/wallet_screen');
      
      } catch (e) {
      } finally {
        state = state.copyWith(isPosting: false);
      }
    } else {
      updateExpense(createObjectExpense(), context);
    }
  }

  Future getExpenses() async {
    state = state.copyWith(isPosting: true);  
    try {
      final token = await keyValueStorage.getValue<String>('token');
      
      final resp = await tripRepository.getExpenses(tripNotifier.state.trip!.tripId, token!);

      final expenses = ( resp['expenses'] as List).map((expense) {
        return Expense.fromJson(expense);
      }).toList();

      for (var expense in expenses) {
        expense.isMine = expense.userId == userState.user!.userId;
      }

      final total = expenses.fold(0.0, (sum, element) => sum + element.expenseAmount);

      state = state.copyWith(expenses: expenses, total: total );
    } catch (e) {
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }

  Future formToUpdate(Expense expense) async {
    state = state.copyWith(
      isEditing: true,
      description: expense.expenseDescription,
      amount: expense.expenseAmount,
      expenseIdEditing: expense.expenseId,
    );
  }

  Future updateExpense(Expense? expense, BuildContext context) async {
    state = state.copyWith(isPosting: true);
    try {
      print("estoy aca intentando hacer un update");  
      final token = await keyValueStorage.getValue<String>('token');
      await tripRepository.updateExpense(expense!, token!);
      await getExpenses();
      context.push('/wallet_screen');
    } catch (e) {
    } finally {
      state = state.copyWith(isPosting: false);
    }
  } 

  Future deleteExpense( BuildContext context) async {
    state = state.copyWith(isPosting: true);
    try {
      final token = await keyValueStorage.getValue<String>('token');
      await tripRepository.deleteExpense(state.expenseIdEditing, userState.user!.userId, token!);
      await getExpenses();
      context.push('/wallet_screen');
    } catch (e) {
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }
}

class ExpenseState {
  final bool isValid;
  final bool isPosting;

  final bool isEditing;
  final int expenseIdEditing;

  final String description;
  final double amount;
  final DateTime? date;
  final String status;
  final int categoryId;

  final List<Expense> expenses;
  final double total;

  ExpenseState({
    this.isPosting = false,
    this.isValid = false,

    this.isEditing = false,
    this.expenseIdEditing = 0,
    
    this.description = '',
    this.amount = 0.0,
    this.date,
    this.status = '',
    this.categoryId = 0,

    this.expenses = const [],
    this.total = 0,
  });

  ExpenseState copyWith({
    bool? isValid,
    bool? isPosting,

    bool? isEditing,
    int? expenseIdEditing,

    String? description,
    double? amount,
    DateTime? date,
    String? status,
    int? categoryId,

    List<Expense>? expenses,
    double? total,
  }) =>

      ExpenseState(
        isValid: isValid ?? this.isValid,
        isPosting: isPosting ?? this.isPosting,

        isEditing: isEditing ?? this.isEditing,
        expenseIdEditing: expenseIdEditing ?? this.expenseIdEditing,

        description: description ?? this.description,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,

        expenses: expenses ?? this.expenses,
        total: total ?? this.total,
      );
}
