import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/business_view_prov/buspageprov_model.dart';
import 'package:unipadonde/validations.dart'; // Importa el archivo de validaciones

class BusinessPageProv extends StatefulWidget {
  final Business business;

  const BusinessPageProv({required this.business});

  @override
  _BusinessPageProvState createState() => _BusinessPageProvState();
}

class _BusinessPageProvState extends State<BusinessPageProv> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  File? _image;

  // Variables para manejar los errores de validación
  String? _nameError;
  String? _descriptionError;
  String? _tiktokError;
  String? _instagramError;
  String? _websiteError;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.business.name;
    descriptionController.text = widget.business.description;
    tiktokController.text = widget.business.tiktok;
    instagramController.text = widget.business.instagram;
    websiteController.text = widget.business.webpage;

    // Agregar listeners para validar en tiempo real
    nameController.addListener(() {
      _validateName(nameController.text);
    });
    descriptionController.addListener(() {
      _validateDescription(descriptionController.text);
    });
    tiktokController.addListener(() {
      _validateTikTok(tiktokController.text);
    });
    instagramController.addListener(() {
      _validateInstagram(instagramController.text);
    });
    websiteController.addListener(() {
      _validateWebsite(websiteController.text);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    tiktokController.dispose();
    instagramController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  // Métodos para validar los campos en tiempo real
  void _validateName(String value) {
    setState(() {
      _nameError = Validations.validateNotEmpty(value, "Nombre del negocio");
    });
  }

  void _validateDescription(String value) {
    setState(() {
      _descriptionError = Validations.validateNotEmpty(value, "Descripción");
    });
  }

  void _validateTikTok(String value) {
    setState(() {
      _tiktokError = Validations.validateNotEmpty(value, "TikTok");
    });
  }

  void _validateInstagram(String value) {
    setState(() {
      _instagramError = Validations.validateNotEmpty(value, "Instagram");
    });
  }

  void _validateWebsite(String value) {
    setState(() {
      _websiteError = Validations.validateNotEmpty(value, "Página web");
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateBusiness() async {
  // Validar todos los campos antes de proceder
  _validateName(nameController.text);
  _validateDescription(descriptionController.text);
  _validateTikTok(tiktokController.text);
  _validateInstagram(instagramController.text);
  _validateWebsite(websiteController.text);

  // Si no hay errores, proceder con la actualización
  if (_nameError == null &&
      _descriptionError == null &&
      _tiktokError == null &&
      _instagramError == null &&
      _websiteError == null) {
    try {
      final client = Supabase.instance.client;
      print("Actualizando negocio en Supabase...");
      await client.from('negocio').update({
        'name': nameController.text,
        'description': descriptionController.text,
        'tiktok': tiktokController.text,
        'instagram': instagramController.text,
        'webpage': websiteController.text,
      }).eq('id', widget.business.id);

      print("Negocio actualizado correctamente");

      // Mostrar el popup de éxito y esperar a que el usuario lo cierre
      await _showUpdateSuccessPopup();

      // Regresar a la vista anterior después de que el usuario cierre el popup
      Navigator.of(context).pop(true); // Envía "true" como resultado

    } catch (e) {
      print("Error al actualizar el negocio: $e");
    }
  }
}

  // Método para mostrar el popup de éxito
  Future<void> _showUpdateSuccessPopup() async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Text(
            "¡Éxito!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'San Francisco',
              fontSize: 25,
              color: Color(0xFF8CB1F1),
            ),
          ),
        ),
        content: Text(
          "La información del negocio se ha actualizado correctamente.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'San Francisco',
            fontSize: 16,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el popup
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontFamily: 'San Francisco',
                color: Color(0xFF8CB1F1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color(0xFFFFA500),
              const Color(0xFF7A9BBF),
              const Color(0xFF8CB1F1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Editar Negocio',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'San Francisco',
            ),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                          color: const Color(0xFFFFA500), width: 4.0),
                    ),
                    child: _image == null
                        ? Icon(Icons.add_a_photo,
                            size: 50, color: Colors.grey[600])
                        : ClipOval(
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              _buildTextField(
                controller: nameController,
                label: 'Nombre del negocio',
                errorText: _nameError,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: descriptionController,
                label: 'Descripción del negocio',
                maxLines: 6,
                errorText: _descriptionError,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: tiktokController,
                label: 'Tiktok',
                errorText: _tiktokError,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: instagramController,
                label: 'Instagram',
                errorText: _instagramError,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: websiteController,
                label: 'Página web',
                errorText: _websiteError,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateBusiness,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA500),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                child: Text('Guardar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(fontFamily: 'San Francisco', fontSize: 19),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(
          fontSize: 20,
          fontFamily: 'San Francisco',
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFA500),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Color(0xFFFFA500), width: 2.0),
        ),
        errorText: errorText, // Muestra el mensaje de error
      ),
    );
  }
}