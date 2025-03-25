import 'package:unipadonde/modeldata/business_model.dart';

class Discount {
  final int id;
  final String name;
  final String description;
  final int porcentaje;
  final String startdate;
  final String enddate;
  final bool state;
  final int idnegocio;
  final int idcategory;
  final Business business;

  Discount(
      {required this.id,
      required this.name,
      required this.description,
      required this.porcentaje,
      required this.startdate,
      required this.enddate,
      required this.state,
      required this.idnegocio,
      required this.business,
      required this.idcategory});

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? "",
      porcentaje: map['porcentaje'] ?? 0,
      startdate: map['startdate'] as String,
      enddate: map['enddate'] as String,
      state: map['state'],
      idnegocio: map['id_negocio'],
      business: map['business'],
      idcategory: map['idcategory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description.isNotEmpty ? description : "",
      'porcentaje': porcentaje != 0 ? porcentaje : 0,
      'startdate': startdate,
      'enddate': enddate,
      'state': state,
      'id_negocio': idnegocio,
    };
  }
}
