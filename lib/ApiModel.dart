
import 'package:flutter/material.dart';

class ApiModel {
  final String longitude;
  final String latitude;
  final String speed;

  ApiModel({
    @required this.longitude,
    @required this.latitude,
    @required this.speed,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      longitude: json['longitude'] as String,
      latitude: json['latitude'] as String,
      speed: json['speed'] as String,
    );
  }
}