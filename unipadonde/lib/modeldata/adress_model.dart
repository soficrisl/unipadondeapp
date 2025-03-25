class Address {
  final int id;
  final int id_negocio;
  final String estado;
  final String ciudad;
  final String municipio;
  final String calle;
  final String additional_info;

  Address({
    required this.id,
    required this.id_negocio,
    required this.estado,
    required this.ciudad,
    required this.municipio,
    required this.calle,
    required this.additional_info,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      id_negocio: map['id_negocio'],
      estado: map['estado'] ?? "",
      ciudad: map['ciudad'] ?? "",
      municipio: map['municipio'] ?? "",
      calle: map['calle'] ?? "",
      additional_info: map['additional_info'] ?? "",
    );
  }
}
