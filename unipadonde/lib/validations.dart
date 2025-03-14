class Validations {
  // Validación para campos no vacíos
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName no puede estar vacío";
    }
    return null;
  }

  // Validación para el campo de correo electrónico
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "El correo electrónico no puede estar vacío";
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return "Ingrese un correo electrónico válido";
    }
    return null;
  }

  // Validación para el campo de nombre
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "El nombre no puede estar vacío";
    }
    return null;
  }

  // Validación para el campo de descripción
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "La descripción no puede estar vacía";
    }
    return null;
  }

  // Validación para el campo de porcentaje
  static String? validatePercentage(String? value) {
    if (value == null || value.isEmpty) {
      return "El porcentaje no puede estar vacío";
    }
    if (int.tryParse(value) == null) {
      return "Debe ser un número entero";
    }
    return null;
  }

  // Validación para las fechas
  static String? validateDates(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return "Debe seleccionar las fechas";
    }
    if (startDate.isAfter(endDate)) {
      return "La fecha de inicio no puede ser posterior a la fecha de fin";
    }
    return null;
  }

  // Validación para el campo de teléfono
static String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return "El teléfono no puede estar vacío";
  }
  if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
    return "Ingrese un número de teléfono válido (10 dígitos)";
  }
  return null;
}


}