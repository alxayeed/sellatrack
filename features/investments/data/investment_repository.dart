import '../domain/entities/investment.dart';

class InvestmentRepository {
  // Singleton instance
  static final InvestmentRepository _instance = InvestmentRepository._internal();

  factory InvestmentRepository() {
    return _instance;
  }

  InvestmentRepository._internal();

  final List<Investment> _investments = [];

  List<Investment> getInvestments() {
    return List.from(_investments);
  }

  void addInvestment(Investment investment) {
    _investments.add(investment);
  }

  void updateInvestment(Investment investment) {
    final index = _investments.indexWhere((i) => i.id == investment.id);
    if (index != -1) {
      _investments[index] = investment;
    }
  }

  void addReturnEntry(String investmentId, ReturnEntry returnEntry) {
    final index = _investments.indexWhere((i) => i.id == investmentId);
    if (index != -1) {
      _investments[index].returns.add(returnEntry);
    }
  }
}
