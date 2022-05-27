class Salary {
  double _value;
  int receiptDate;
  double _advance;
  int? advanceDate;
  bool fixDate;

  Salary({
    required double value,
    required this.receiptDate,
    double advance = 0,
    this.advanceDate,
      bool this.fixDate = false
  })
      : _advance = advance,
        _value = value;

  double get advance {
    return _advance;
  }

  void setAdvance({required double value, required int advanceDate}) {
    _advance = value;
    this.advanceDate = advanceDate;
  }

  double get value {
    return _value - _advance;
  }

  set value(double value) => _value = value;
}
