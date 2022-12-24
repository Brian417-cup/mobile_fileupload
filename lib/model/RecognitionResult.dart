class RecognitionResult {
  bool? _isSuccess;
  String? _res;

  RecognitionResult({bool? isSuccess, String? res}) {
    if (isSuccess != null) {
      this._isSuccess = isSuccess;
    }
    if (res != null) {
      this._res = res;
    }
  }

  bool? get isSuccess => _isSuccess;

  set isSuccess(bool? isSuccess) => _isSuccess = isSuccess;

  String? get res => _res;

  set res(String? res) => _res = res;

  RecognitionResult.fromJson(Map<String, dynamic> json) {
    _isSuccess = json['IsSuccess'];
    _res = json['Res'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this._isSuccess;
    data['Res'] = this._res;
    return data;
  }
}
