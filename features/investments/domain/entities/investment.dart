enum InvestmentStatus {
  active,
  returnsStarted,
  completed,
  loss,
}

class ReturnEntry {
  final String id;
  final double amountReceived;
  final DateTime date;
  final String transactionId;
  final String medium;
  final String notes;

  ReturnEntry({
    required this.id,
    required this.amountReceived,
    required this.date,
    required this.transactionId,
    required this.medium,
    required this.notes,
  });
}

class Investment {
  final String id;
  final String title;
  final double amountInvested;
  final DateTime startDate;
  final DateTime expectedEndDate;
  final String platformName;
  final double profitRate;
  final double expectedROI;
  final String notes;
  final String docLinks;
  final String transactionId;
  final String transactionMedium;
  final DateTime transactionDate;
  InvestmentStatus status;
  final List<ReturnEntry> returns;

  Investment({
    required this.id,
    required this.title,
    required this.amountInvested,
    required this.startDate,
    required this.expectedEndDate,
    required this.platformName,
    required this.profitRate,
    required this.expectedROI,
    required this.notes,
    required this.docLinks,
    required this.transactionId,
    required this.transactionMedium,
    required this.transactionDate,
    required this.status,
    required this.returns,
  });
}
