import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/data/models/invoice.dart';
import 'package:frontend_appflowershop/data/services/invoice/api_invoice.dart';
import 'admin_total_event.dart';
import 'admin_total_state.dart';
import 'package:intl/intl.dart';

class AdminTotalBloc extends Bloc<AdminTotalEvent, AdminTotalState> {
  final ApiInvoice _apiInvoice;

  AdminTotalBloc({ApiInvoice? apiInvoice})
      : _apiInvoice = apiInvoice ?? ApiInvoice(),
        super(AdminTotalLoading()) {
    on<FetchInvoicesEvent>(_onFetchInvoices);
    on<ChangeMonthEvent>(_onChangeMonth);
    on<ChangeWeekEvent>(_onChangeWeek);
  }

  Future<void> _onFetchInvoices(
      FetchInvoicesEvent event, Emitter<AdminTotalState> emit) async {
    developer.log('[AdminTotalBloc] Starting to fetch invoices');
    emit(AdminTotalLoading());

    try {
      final invoices = await _apiInvoice.getAllInvoices();
      developer.log(
          '[AdminTotalBloc] Invoices fetched successfully: ${invoices.length} invoices');

      final availableMonths = _generateAvailableMonths(invoices);
      if (availableMonths.isEmpty) {
        emit(AdminTotalLoaded(
          invoices: invoices,
          selectedMonth: '',
          selectedWeek: '',
          availableMonths: [],
          availableWeeks: [],
        ));
        return;
      }

      final latestMonth = availableMonths.last;
      final availableWeeks = _generateAvailableWeeks(latestMonth);

      emit(AdminTotalLoaded(
        invoices: invoices,
        selectedMonth: latestMonth,
        selectedWeek: availableWeeks.isNotEmpty ? availableWeeks.first : '',
        availableMonths: availableMonths,
        availableWeeks: availableWeeks,
      ));
    } catch (e) {
      developer.log('[AdminTotalBloc] Error: $e');
      emit(AdminTotalError('Lỗi: $e'));
    }
  }

  Future<void> _onChangeMonth(
      ChangeMonthEvent event, Emitter<AdminTotalState> emit) async {
    if (state is AdminTotalLoaded) {
      final currentState = state as AdminTotalLoaded;
      developer.log('[AdminTotalBloc] Changing month to: ${event.month}');

      final availableWeeks = _generateAvailableWeeks(event.month);

      emit(AdminTotalLoaded(
        invoices: currentState.invoices,
        selectedMonth: event.month,
        selectedWeek: availableWeeks.isNotEmpty ? availableWeeks.first : '',
        availableMonths: currentState.availableMonths,
        availableWeeks: availableWeeks,
      ));
    }
  }

  Future<void> _onChangeWeek(
      ChangeWeekEvent event, Emitter<AdminTotalState> emit) async {
    if (state is AdminTotalLoaded) {
      final currentState = state as AdminTotalLoaded;
      developer.log('[AdminTotalBloc] Changing week to: ${event.week}');
      emit(AdminTotalLoaded(
        invoices: currentState.invoices,
        selectedMonth: currentState.selectedMonth,
        selectedWeek: event.week,
        availableMonths: currentState.availableMonths,
        availableWeeks: currentState.availableWeeks,
      ));
    }
  }

  List<String> _generateAvailableMonths(List<Invoice> invoices) {
    final months = <String>{};
    for (var invoice in invoices) {
      final month = DateFormat('yyyy-MM').format(invoice.createdAt);
      months.add(month);
    }
    final sortedMonths = months.toList()..sort();
    return sortedMonths;
  }

  List<String> _generateAvailableWeeks(String month) {
    if (month.isEmpty) return [];
    final yearMonth = month.split('-');
    final year = int.parse(yearMonth[0]);
    final monthNum = int.parse(yearMonth[1]);
    final firstDayOfMonth = DateTime(year, monthNum, 1);
    final lastDayOfMonth = DateTime(year, monthNum + 1, 0);
    final totalDays = lastDayOfMonth.day;

    final weeks = <String>[];
    int currentDay = 1;
    int weekNumber = 1;

    while (currentDay <= totalDays) {
      weeks.add('Tuần $weekNumber');
      currentDay += 7;
      weekNumber++;
    }

    return weeks;
  }
}
