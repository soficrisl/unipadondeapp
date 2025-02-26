class Discount {
  final int? id;
  final String name;
  final String description;
  final int porcentaje;
  final DateTime startDate;
  final DateTime endDate;
  final bool state;
  final int idNegocio;

  Discount({
    this.id,
    required this.name,
    required this.description,
    required this.porcentaje,
    required this.startDate,
    required this.endDate,
    required this.state,
    required this.idNegocio,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'porcentaje': porcentaje,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'state': state,
      'idNegocio': idNegocio,
    };
  }
}
