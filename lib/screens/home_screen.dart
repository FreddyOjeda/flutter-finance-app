import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user.dart';
import '../models/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = User(name: 'Freddy Ojeda', email: 'freddy@email.com');
  List<Transaction> transactions = [
    Transaction(
        description: "Salario",
        amount: 2000,
        isIncome: true,
        date: DateTime.now()),
    Transaction(
        description: "Comida",
        amount: -150,
        isIncome: false,
        date: DateTime.now()),
    Transaction(
        description: "Transporte",
        amount: -50,
        isIncome: false,
        date: DateTime.now()),
  ];

  double get totalBalance {
    return transactions.fold(0, (sum, tx) => sum + tx.amount);
  }

  double get incomePercentage {
    final income = transactions
        .where((tx) => tx.isIncome)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    return totalBalance > 0 ? (income / totalBalance) * 100 : 0;
  }

  List<FlSpot> getMonthlyData() {
    return [
      const FlSpot(1, 1000),
      const FlSpot(2, 1500),
      const FlSpot(3, 1300),
      const FlSpot(4, 1700),
      const FlSpot(5, 2000),
      const FlSpot(6, 1800),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finance App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Balance Actual",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text("\$${totalBalance.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: totalBalance >= 0 ? Colors.green : Colors.red,
                        )),
                    const SizedBox(height: 10),
                    Text("Ingresos: ${incomePercentage.toStringAsFixed(2)}%",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Comparación Mensual",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: getMonthlyData(),
                              isCurved: true,
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.blueAccent
                                ], // Puedes agregar más colores si quieres
                              ),
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          titlesData: const FlTitlesData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(user.email),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  // Aquí puedes redirigir a la pantalla de perfil si lo deseas
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
