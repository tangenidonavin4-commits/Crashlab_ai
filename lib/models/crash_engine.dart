import 'dart:math';

class CrashEngine {
  final Random _random = Random();
  double _currentMultiplier = 1.0;
  bool _isCrashed = false;
  double _crashPoint = 1.0;
  
  double generateCrashPoint() {
    double r = _random.nextDouble();
    if (r < 0.30) return 1.0 + _random.nextDouble() * 0.5;
    if (r < 0.60) return 1.5 + _random.nextDouble() * 0.5;
    if (r < 0.80) return 2.0 + _random.nextDouble() * 1.0;
    if (r < 0.95) return 3.0 + _random.nextDouble() * 3.0;
    return 6.0 + _random.nextDouble() * 4.0;
  }
  
  void startRound() {
    _crashPoint = generateCrashPoint();
    _currentMultiplier = 1.0;
    _isCrashed = false;
  }
  
  void updateMultiplier(double elapsed) {
    if (_isCrashed) return;
    
    _currentMultiplier = 1.0 + elapsed * 1.2 + _random.nextDouble() * 0.1;
    
    if (_currentMultiplier >= _crashPoint) {
      _currentMultiplier = _crashPoint;
      _isCrashed = true;
    }
  }
  
  bool get isCrashed => _isCrashed;
  double get currentMultiplier => _currentMultiplier;
  double get crashPoint => _crashPoint;
}
