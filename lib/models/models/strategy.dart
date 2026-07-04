enum StrategyType { fixed, martingale, conservative }

class Strategy {
  StrategyType type;
  double baseBet;
  double targetMultiplier;
  int currentStreak;
  double currentBankroll;
  int totalRounds;
  int wins;
  int losses;
  
  Strategy({
    this.type = StrategyType.fixed,
    this.baseBet = 50.0,
    this.targetMultiplier = 2.0,
    this.currentStreak = 0,
    this.currentBankroll = 5000.0,
    this.totalRounds = 0,
    this.wins = 0,
    this.losses = 0,
  });
  
  double calculateBet() {
    switch (type) {
      case StrategyType.fixed:
        return baseBet;
      case StrategyType.martingale:
        return baseBet * (currentStreak + 1);
      case StrategyType.conservative:
        return currentBankroll * 0.02;
    }
  }
  
  double calculateCashOut(double crashPoint) {
    if (crashPoint >= targetMultiplier) {
      return targetMultiplier;
    }
    return 0;
  }
  
  void updateResult(bool won, double profit) {
    totalRounds++;
    if (won) {
      wins++;
      currentStreak = 0;
      currentBankroll += profit;
    } else {
      losses++;
      currentStreak++;
      currentBankroll -= calculateBet();
    }
  }
  
  double get winRate => totalRounds > 0 ? wins / totalRounds : 0;
}
