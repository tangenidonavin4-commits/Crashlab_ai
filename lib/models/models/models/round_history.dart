class Round {
  final int id;
  final double crashPoint;
  final double cashOutMultiplier;
  final double betAmount;
  final double profit;
  final DateTime timestamp;
  final bool isWin;
  
  Round({
    required this.id,
    required this.crashPoint,
    required this.cashOutMultiplier,
    required this.betAmount,
    required this.profit,
    required this.timestamp,
    required this.isWin,
  });
}
