class SensorDataModel {

  final double temperature;
  final double humidity;
  final int battery;
  final bool status;

  SensorDataModel({
    required this.temperature,
    required this.humidity,
    required this.battery,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "temperature": temperature,
      "humidity": humidity,
      "battery": battery,
      "status": status,
    };
  }
}