import 'package:flutter/material.dart';

class WeatherForDate {
  final DateTime date;
  final String condition;
  final double temperature;
  final IconData icon;

  WeatherForDate({
    required this.date,
    required this.condition,
    required this.temperature,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'temperature': temperature,
    'condition': condition,
    'icon': icon,
  };

  static WeatherForDate fromJson(Map<String, dynamic> json) {
    return WeatherForDate(
      date: DateTime.parse(json['date']),
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition'],
      icon: json['icon'],
    );
  }
}
