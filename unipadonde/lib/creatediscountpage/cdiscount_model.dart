class Discount {
  final int? id;
  final String name;
  final String description;
  final int porcentaje;
  final DateTime startdate;
  final DateTime enddate;
  final bool state;
  final int id_negocio;

  Discount({
    this.id,
    required this.name,
    required this.description,
    required this.porcentaje,
    required this.startdate,
    required this.enddate,
    required this.state,
    required this.id_negocio,
  });

  Map<String, dynamic> toMap() {
    return {
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
