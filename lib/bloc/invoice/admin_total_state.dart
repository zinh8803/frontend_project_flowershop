import 'package:frontend_appflowershop/data/models/invoice.dart';

abstract class AdminTotalState {}

class AdminTotalLoading extends AdminTotalState {}

class AdminTotalLoaded extends AdminTotalState {
  final List<Invoice> invoices;
  final String selectedMonth; // VD: "2025-04"
  final String selectedWeek; // VD: "Tuần 1"
  final List<String> availableMonths; // VD: ["2025-03", "2025-04"]
  final List<String> availableWeeks; // VD: ["Tuần 1", "Tuần 2", ...]

  AdminTotalLoaded({
    required this.invoices,
    required this.selectedMonth,
    required this.selectedWeek,
    required this.availableMonths,
    required this.availableWeeks,
  });
}

class AdminTotalError extends AdminTotalState {
  final String message;

  AdminTotalError(this.message);
}
