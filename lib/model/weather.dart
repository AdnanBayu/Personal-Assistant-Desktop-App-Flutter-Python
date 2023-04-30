class Weather {
  final double temperatureC;
  final double temperatureF;
  final String condition;
  final String name;
  final String region;
  final String country;
  final String localTime;

  Weather({
    this.temperatureC = 0,
    this.temperatureF = 0,
    this.condition = "Sunny",
    this.name = "Somewhere",
    this.region = "Somewhere",
    this.country = "Somewhere",
    this.localTime = "Sometime",
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperatureC: json['current']['temp_c'],
      temperatureF: json['current']['temp_f'],
      condition: json['current']['condition']['text'],
      name: json['location']['name'],
      region: json['location']['region'],
      country: json['location']['country'],
      localTime: json['location']['localtime']
    );
  }
}