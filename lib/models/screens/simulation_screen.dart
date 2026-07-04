import 'package:flutter/material.dart';
import '../models/crash_engine.dart';
import '../models/strategy.dart';
import '../models/round_history.dart';
import '../widgets/bankroll_chart.dart';

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
  List<double> bankrollHistory = [];  // ← ADD THIS!

  // ... rest of your code ...
}
