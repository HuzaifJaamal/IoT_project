import '../providers/google_sheet_provider.dart';

class SensorRepository {

  final GoogleSheetProvider _provider =
  GoogleSheetProvider();

  Future<void> saveData({
    required double temperature,
    required double humidity,
    required int battery,
    required bool status,
  }) async {

    await _provider.saveSensorData(
      temperature: temperature,
      humidity: humidity,
      battery: battery,
      status: status,
    );
  }
  Future<List<dynamic>> getHistory() {
    return _provider.getHistory();
  }
}