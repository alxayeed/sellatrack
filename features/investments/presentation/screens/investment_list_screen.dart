import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/investment_repository.dart';
import '../../domain/entities/investment.dart';
import '../../../../core/navigation/app_router.dart';

class InvestmentListScreen extends StatefulWidget {
  const InvestmentListScreen({super.key});

  @override
  State<InvestmentListScreen> createState() => _InvestmentListScreenState();
}

class _InvestmentListScreenState extends State<InvestmentListScreen> {
  final InvestmentRepository _repository = InvestmentRepository();
  late List<Investment> _investments;

  @override
  void initState() {
    super.initState();
    _investments = _repository.getInvestments();
  }

  void _refreshInvestments() {
    setState(() {
      _investments = _repository.getInvestments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
      ),
      body: _investments.isEmpty
          ? const Center(
              child: Text('No investments yet. Add one!'),
            )
          : ListView.builder(
              itemCount: _investments.length,
              itemBuilder: (context, index) {
                final investment = _investments[index];
                return ListTile(
                  title: Text(investment.title),
                  subtitle: Text(investment.platformName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${investment.amountInvested.toStringAsFixed(2)}'),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await context.push(AppRoutes.editInvestment, extra: investment);
                          _refreshInvestments();
                        },
                      ),
                    ],
                  ),
                  onTap: () async {
                    await context.push(AppRoutes.investmentDetails, extra: investment);
                    _refreshInvestments();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(AppRoutes.addInvestment);
          _refreshInvestments();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
