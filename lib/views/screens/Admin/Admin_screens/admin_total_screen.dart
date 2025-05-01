import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend_appflowershop/bloc/invoice/admin_total_bloc.dart';
import 'package:frontend_appflowershop/bloc/invoice/admin_total_event.dart';
import 'package:frontend_appflowershop/bloc/invoice/admin_total_state.dart';
import 'package:frontend_appflowershop/data/models/invoice.dart';
import 'package:frontend_appflowershop/data/services/invoice/api_invoice.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminTotalScreen extends StatelessWidget {
  const AdminTotalScreen({super.key});

  Map<String, dynamic> _calculateStats(
      List<Invoice> invoices, String selectedMonth, String selectedWeek) {
    if (selectedMonth.isEmpty || selectedWeek.isEmpty) {
      return {
        'totalRevenue': 0.0,
        'cashRevenue': 0.0,
        'vnpayRevenue': 0.0,
        'startDate': DateTime.now(),
        'endDate': DateTime.now(),
      };
    }

    // Parse tháng được chọn
    final yearMonth = selectedMonth.split('-');
    final year = int.parse(yearMonth[0]);
    final month = int.parse(yearMonth[1]);
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);

    // Tính ngày bắt đầu và kết thúc của tuần
    final weekNumber = int.parse(selectedWeek.replaceAll('Tuần ', ''));
    final startDay = (weekNumber - 1) * 7 + 1;
    final endDay =
        startDay + 6 > lastDayOfMonth.day ? lastDayOfMonth.day : startDay + 6;

    final startDate = DateTime(year, month, startDay);
    final endDate = DateTime(year, month, endDay, 23, 59, 59);

    developer.log(
        '[AdminTotalScreen] Selected Month: $selectedMonth, Week: $selectedWeek');
    developer.log('[AdminTotalScreen] StartDate: $startDate');
    developer.log('[AdminTotalScreen] EndDate: $endDate');

    double totalRevenue = 0.0;
    double cashRevenue = 0.0;
    double vnpayRevenue = 0.0;

    for (var invoice in invoices) {
      final isInRange = invoice.createdAt.isAfter(startDate) &&
          invoice.createdAt.isBefore(endDate.add(const Duration(days: 1)));
      developer.log(
          '[AdminTotalScreen] Invoice ID: ${invoice.id}, CreatedAt: ${invoice.createdAt}, In Range: $isInRange');
      if (isInRange) {
        totalRevenue += invoice.totalPrice;
        if (invoice.paymentMethod == 'cash') {
          cashRevenue += invoice.totalPrice;
        } else if (invoice.paymentMethod == 'vnpay') {
          vnpayRevenue += invoice.totalPrice;
        }
      }
    }

    developer.log('[AdminTotalScreen] Total Revenue: $totalRevenue');
    developer.log('[AdminTotalScreen] Cash Revenue: $cashRevenue');
    developer.log('[AdminTotalScreen] VNPay Revenue: $vnpayRevenue');

    return {
      'totalRevenue': totalRevenue.toDouble(),
      'cashRevenue': cashRevenue.toDouble(),
      'vnpayRevenue': vnpayRevenue.toDouble(),
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AdminTotalBloc(apiInvoice: ApiInvoice())..add(FetchInvoicesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Tổng'),
          backgroundColor: Colors.green[700],
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                PreferenceService.clearToken().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng xuất thành công')),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                });
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green[50]!, Colors.green[100]!],
            ),
          ),
          child: BlocBuilder<AdminTotalBloc, AdminTotalState>(
            builder: (context, state) {
              if (state is AdminTotalLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AdminTotalError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 60, color: Colors.red[400]),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else if (state is AdminTotalLoaded) {
                final stats = _calculateStats(
                    state.invoices, state.selectedMonth, state.selectedWeek);
                final formatter =
                    NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thống kê doanh thu',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                value: state.selectedMonth.isEmpty
                                    ? null
                                    : state.selectedMonth,
                                hint: const Text('Chọn tháng'),
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<AdminTotalBloc>()
                                        .add(ChangeMonthEvent(value));
                                  }
                                },
                                items: state.availableMonths.map((month) {
                                  final yearMonth = month.split('-');
                                  final formattedMonth =
                                      'Tháng ${int.parse(yearMonth[1])}/${yearMonth[0]}';
                                  return DropdownMenuItem(
                                    value: month,
                                    child: Text(formattedMonth),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButton<String>(
                                value: state.selectedWeek.isEmpty
                                    ? null
                                    : state.selectedWeek,
                                hint: const Text('Chọn tuần'),
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<AdminTotalBloc>()
                                        .add(ChangeWeekEvent(value));
                                  }
                                },
                                items: state.availableWeeks.map((week) {
                                  return DropdownMenuItem(
                                    value: week,
                                    child: Text(week),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side:
                                BorderSide(color: Colors.green[50]!, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tổng doanh thu (${DateFormat('dd/MM/yyyy').format(stats['startDate'])} - ${DateFormat('dd/MM/yyyy').format(stats['endDate'])})',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formatter.format(stats['totalRevenue']),
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Phân loại theo phương thức thanh toán',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Table(
                                  border:
                                      TableBorder.all(color: Colors.grey[300]!),
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.green[50]),
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Phương thức',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Doanh thu',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Tiền mặt (Cash)'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(formatter
                                              .format(stats['cashRevenue'])),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('VNPay'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(formatter
                                              .format(stats['vnpayRevenue'])),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Biểu đồ doanh thu',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 200,
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: ((stats['totalRevenue'] as double) /
                                                  100000)
                                              .ceil() *
                                          100000,
                                      barTouchData:
                                          BarTouchData(enabled: false),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              switch (value.toInt()) {
                                                case 0:
                                                  return const Text('Tiền mặt');
                                                case 1:
                                                  return const Text('VNPay');
                                                default:
                                                  return const Text('');
                                              }
                                            },
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                formatter
                                                    .format(value)
                                                    .split(' ')[0],
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              );
                                            },
                                          ),
                                        ),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      barGroups: [
                                        BarChartGroupData(
                                          x: 0,
                                          barRods: [
                                            BarChartRodData(
                                              toY: (stats['cashRevenue']
                                                  as double),
                                              color: Colors.green[700],
                                              width: 20,
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(4)),
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 1,
                                          barRods: [
                                            BarChartRodData(
                                              toY: (stats['vnpayRevenue']
                                                  as double),
                                              color: Colors.blue[700],
                                              width: 20,
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(4)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
