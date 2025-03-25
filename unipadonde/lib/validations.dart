import 'package:intl/intl.dart';

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
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Ingrese un correo electrónico válido";
    }
    return null;
  }

  // Validación para el campo de nombre
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "El nombre no puede estar vacío";
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return "Ingrese un nombre válido (solo letras)";
    }
    return null;
  }

  // Validación para el campo de apellido
  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return "El apellido no puede estar vacío";
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return "Ingrese un apellido válido (solo letras)";
    }
    return null;
  }

  // Validación para el campo de cédula (CI)
  static String? validateCI(String? value) {
    if (value == null || value.isEmpty) {
      return "La cédula no puede estar vacía";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Ingrese solo números";
    }
    return null;
  }

  // Validación para el campo de contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "La contraseña no puede estar vacía";
    }
    if (!RegExp(r'^[a-zA-Z0-9&%_\-=@,\.;\*\+\$\\]+$').hasMatch(value)) {
      return "Ingrese una contraseña válida";
    }
    if (value.length < 6) {
      return 'La contraseña debe tener más de 6 caracteres.';
    }
    return null;
  }

  // Validación para el campo de RIF
  static String? validateRIFNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de RIF es requerido';
    }
    if (value.length != 9 && value.length != 10) {
      return 'El número de RIF debe tener 9 o 10 dígitos';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Solo se permiten números';
    }
    return null;
  }

  // Validación para el campo de sexo
  static String? validateSex(String? value) {
    if (value == null || value.isEmpty) {
      return "El sexo no puede estar vacío";
    }
    if (value != "Femenino" && value != "Masculino") {
      return "Seleccione un sexo válido";
    }
    return null;
  }

  // Validación para el campo de universidad
  static String? validateUniversity(String? value) {
    if (value == null || value.isEmpty) {
      return "La universidad no puede estar vacía";
    }
    return null;
  }

  // Validación para el campo de negocio
  static String? validateBusiness(String? value) {
    if (value == null || value.isEmpty) {
      return "El nombre del negocio no puede estar vacío";
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

  static String formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return dateFormat.format(dateTime);
  }
}