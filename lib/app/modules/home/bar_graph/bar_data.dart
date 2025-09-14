import 'package:sls_app/app/modules/home/bar_graph/individul_bar.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
  });
  List<IndividulBar> barData = [];
  // initialize bar data
  void initializeBarData() {
    barData = [
      IndividulBar(x: 0, y: sunAmount),
      IndividulBar(x: 1, y: monAmount),
      IndividulBar(x: 2, y: tueAmount),
      IndividulBar(x: 3, y: wedAmount),
      IndividulBar(x: 4, y: thuAmount),
      IndividulBar(x: 5, y: friAmount),
      IndividulBar(x: 6, y: satAmount),
    ];
  }

  // get bar data
}
