abstract class AdminTotalEvent {}

class FetchInvoicesEvent extends AdminTotalEvent {}

class ChangeMonthEvent extends AdminTotalEvent {
  final String month; // VD: "2025-04"

  ChangeMonthEvent(this.month);
}

class ChangeWeekEvent extends AdminTotalEvent {
  final String week; // VD: "Tuần 1"

  ChangeWeekEvent(this.week);
}
