import 'package:flutter/material.dart';
import '../models/crash_engine.dart';
import '../models/strategy.dart';
import '../models/round_history.dart';

class SimulationScreen extends StatefulWidget {
  @override
  _SimulationScreenState createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  final CrashEngine _engine = CrashEngine();
  Strategy _strategy = Strategy(type: StrategyType.fixed);
  List<Round> _history = [];
  bool _isRunning = false;
  double _elapsed = 0.0;
  int _roundCount = 0;
  
  void _startRound() {
    setState(() {
      _isRunning = true;
      _elapsed = 0.0;
      _engine.startRound();
    });
    
    _simulateRound();
  }
  
  void _simulateRound() {
    Future.delayed(Duration(milliseconds: 50), () {
      if (!_isRunning) return;
      
      setState(() {
        _elapsed += 0.05;
        _engine.updateMultiplier(_elapsed);
      });
      
      if (!_engine.isCrashed) {
        _simulateRound();
      } else {
        _endRound();
      }
    });
  }
  
  void _endRound() {
    double crashPoint = _engine.crashPoint;
    double betAmount = _strategy.calculateBet();
    double cashOut = _strategy.calculateCashOut(crashPoint);
    bool isWin = cashOut > 0;
    double profit = isWin ? (betAmount * cashOut) - betAmount : -betAmount;
    
    setState(() {
      _roundCount++;
      _strategy.updateResult(isWin, profit);
      
      _history.add(Round(
        id: _roundCount,
        crashPoint: crashPoint,
        cashOutMultiplier: cashOut,
        betAmount: betAmount,
        profit: profit,
        timestamp: DateTime.now(),
        isWin: isWin,
      ));
      
      _isRunning = false;
    });
  }
  
  void _resetBankroll() {
    setState(() {
      _strategy = Strategy(type: _strategy.type);
      _history = [];
      _roundCount = 0;
    });
  }
  
  void _changeStrategy(StrategyType type) {
    setState(() {
      _strategy = Strategy(type: type, baseBet: _strategy.baseBet);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CrashLab AI Simulator"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetBankroll,
            tooltip: 'Reset Bankroll',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("BANKROLL", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                        "N\$${_strategy.currentBankroll.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("ROUNDS", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text("$_roundCount", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12),
            
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat("Wins", _strategy.wins.toString(), Colors.green),
                  _buildStat("Losses", _strategy.losses.toString(), Colors.red),
                  _buildStat("Win Rate", "${(_strategy.winRate * 100).toStringAsFixed(1)}%", Colors.blue),
                  _buildStat("Streak", _strategy.currentStreak.toString(), Colors.orange),
                ],
              ),
            ),
            
            SizedBox(height: 12),
            
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _engine.isCrashed 
                        ? [Colors.red.shade900, Colors.red.shade800]
                        : [Colors.green.shade900, Colors.green.shade800],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _engine.isCrashed ? "💥 CRASHED" : "🚀 FLYING",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${_engine.currentMultiplier.toStringAsFixed(2)}x",
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (_engine.isCrashed)
                      Text(
                        "Crashed at ${_engine.crashPoint.toStringAsFixed(2)}x",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    if (!_engine.isCrashed && _isRunning)
                      Text(
                        "Target: ${_strategy.targetMultiplier}x",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 12),
            
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Strategy:", style: TextStyle(color: Colors.grey)),
                  Row(
                    children: [
                      _buildStrategyChip(StrategyType.fixed, "Fixed"),
                      SizedBox(width: 8),
                      _buildStrategyChip(StrategyType.martingale, "Martingale"),
                      SizedBox(width: 8),
                      _buildStrategyChip(StrategyType.conservative, "Safe"),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? null : _startRound,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(0, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isRunning ? "RUNNING..." : "▶ START ROUND",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: _history.isEmpty
                  ? Center(child: Text("No rounds yet", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _history.length > 20 ? 20 : _history.length,
                      itemBuilder: (context, index) {
                        int i = _history.length - 1 - index;
                        if (i < 0) return Container();
                        var round = _history[i];
                        return Container(
                          width: 50,
                          margin: EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: round.isWin ? Colors.green.shade900 : Colors.red.shade900,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "#${round.id}",
                                style: TextStyle(fontSize: 10, color: Colors.white70),
                              ),
                              Text(
                                "${round.crashPoint.toStringAsFixed(1)}x",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                round.isWin ? "✅" : "❌",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 10)),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
  
  Widget _buildStrategyChip(StrategyType type, String label) {
    bool isSelected = _strategy.type == type;
    return GestureDetector(
      onTap: () => _changeStrategy(type),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
