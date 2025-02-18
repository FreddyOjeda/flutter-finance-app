import 'package:flutter/material.dart';
import '../models/transaction.dart';

class MovementsScreen extends StatefulWidget {
  const MovementsScreen({super.key});

  @override
  State<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  final List<Transaction> transactions = [];

  void _addTransaction() {
    final _descController = TextEditingController();
    final _amountController = TextEditingController();
    bool _isIncome = true; // Valor por defecto (Ingreso)

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Agregar Movimiento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButton<bool>(
                value: _isIncome,
                items: const [
                  DropdownMenuItem(value: true, child: Text('Ingreso')),
                  DropdownMenuItem(value: false, child: Text('Egreso')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _isIncome = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newDescription = _descController.text;
                final newAmount = double.tryParse(_amountController.text) ?? 0;

                if (newDescription.isNotEmpty && newAmount > 0) {
                  setState(() {
                    transactions.add(Transaction(
                      description: newDescription,
                      amount: newAmount,
                      isIncome: _isIncome,
                      date: DateTime.now(),
                    ));
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _editTransaction(int index) {
    final transaction = transactions[index];

    if (DateTime.now().difference(transaction.date).inMinutes > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solo puedes editar dentro de los primeros 10 minutos.')),
      );
      return;
    }

    final _descController = TextEditingController(text: transaction.description);
    final _amountController = TextEditingController(text: transaction.amount.toString());
    bool _isIncome = transaction.isIncome;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Editar Movimiento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButton<bool>(
                value: _isIncome,
                items: const [
                  DropdownMenuItem(value: true, child: Text('Ingreso')),
                  DropdownMenuItem(value: false, child: Text('Egreso')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _isIncome = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newDescription = _descController.text;
                final newAmount = double.tryParse(_amountController.text) ?? 0;

                if (newDescription.isNotEmpty && newAmount > 0) {
                  setState(() {
                    transactions[index] = Transaction(
                      description: newDescription,
                      amount: newAmount,
                      isIncome: _isIncome,
                      date: transaction.date,
                    );
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      body: transactions.isEmpty
          ? const Center(child: Text('No hay movimientos registrados'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final color = tx.isIncome ? Colors.green : Colors.red;

                return Card(
                  child: ListTile(
                    title: Text(
                      tx.description,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(tx.date.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editTransaction(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }
}
