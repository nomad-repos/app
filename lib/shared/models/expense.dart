
import 'dart:convert';

Expense expenseFromJson(String str) => Expense.fromJson(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toJson());

class Expense {
  int categoryId;
  double expenseAmount;
  DateTime expenseDate;
  String expenseDescription;
  String expenseStatus;
  int tripId;
  int userId;

  Expense({
    required this.categoryId,
    required this.expenseAmount,
    required this.expenseDate,
    required this.expenseDescription,
    required this.expenseStatus,
    required this.tripId,
    required this.userId,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        categoryId: json["category_id"],
        expenseAmount: json["expense_amount"],
        expenseDate: DateTime.parse(json["expense_date"]),
        expenseDescription: json["expense_description"],
        expenseStatus: json["expense_status"],
        tripId: json["trip_id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "expense_amount": expenseAmount,
        "expense_date":
            "${expenseDate.year.toString().padLeft(4, '0')}-${expenseDate.month.toString().padLeft(2, '0')}-${expenseDate.day.toString().padLeft(2, '0')}",
        "expense_description": expenseDescription,
        "expense_status": expenseStatus,
        "trip_id": tripId,
        "user_id": userId,
      };
}
