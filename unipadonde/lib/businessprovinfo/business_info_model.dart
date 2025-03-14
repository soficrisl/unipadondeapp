
import 'package:supabase_flutter/supabase_flutter.dart';

class Business {
  final int id;
  final String name;
  final String description;
  final String picture;
  final String tiktok;
  final String instagram;
  final String webpage;

  Business({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.tiktok,
    required this.instagram,
    required this.webpage,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      tiktok: json['tiktok'],
      instagram: json['instagram'],
      webpage: json['webpage'],
    );
  }
}

class Discount {
  final int id;
  final String name;
  final String description;
  final int porcentaje;
  final DateTime startdate;
  final DateTime enddate;
  final bool state;
  final int id_negocio;

  Discount({
    required this.id,
    required this.name,
    required this.description,
    required this.porcentaje,
    required this.startdate,
    required this.enddate,
    required this.state,
    required this.id_negocio,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'porcentaje': porcentaje,
      'startdate': startdate.toIso8601String(),
      'enddate': enddate.toIso8601String(),
      'state': state,
      'id_negocio': id_negocio,
    };
  }
}