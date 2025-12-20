import 'package:flutter/material.dart';
import '../../data/investment_repository.dart';
import '../../domain/entities/investment.dart';
import 'add_investment_screen.dart';
import 'investment_detail_screen.dart';
import 'edit_investment_screen.dart';

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

  void _addInvestment(Investment investment) {
    setState(() {
      _repository.addInvestment(investment);
      _investments = _repository.getInvestments();
    });
  }

  void _updateInvestment(Investment investment) {
    setState(() {
      _repository.updateInvestment(investment);
      _investments = _repository.getInvestments();
    });
  }

  void _addReturn(String investmentId, ReturnEntry returnEntry) {
    setState(() {
      _repository.addReturnEntry(investmentId, returnEntry);
      _investments = _repository.getInvestments();
    });
  }

  void _navigateToDetail(Investment investment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InvestmentDetailScreen(
          investment: investment,
          onAddReturn: _addReturn,
        ),
      ),
    ).then((_) => setState(() {
      _investments = _repository.getInvestments();
    }));
  }

  void _navigateToEdit(Investment investment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditInvestmentScreen(
          investment: investment,
          onUpdate: _updateInvestment,
        ),
      ),
    ).then((_) => setState(() {
      _investments = _repository.getInvestments();
    }));
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
                        onPressed: () => _navigateToEdit(investment),
                      ),
                    ],
                  ),
                  onTap: () => _navigateToDetail(investment),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddInvestmentScreen(onSubmit: _addInvestment),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
