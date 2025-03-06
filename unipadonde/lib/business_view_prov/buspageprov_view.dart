import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BusinessPageProv extends StatefulWidget {
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
              const Color(0xFF8CB1F1),
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
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: descriptionController,
                label: 'Descripción del negocio',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: tiktokController,
                label: 'Tiktok',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: instagramController,
                label: 'Instagram',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: websiteController,
                label: 'Página web',
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  print('Nombre: ${nameController.text}');
                  print('Descripción: ${descriptionController.text}');
                  print('Tiktok: ${tiktokController.text}');
                  print('Instagram: ${instagramController.text}');
                  print('Página web: ${websiteController.text}');
                  if (_image != null) {
                    print('Imagen guardada en: ${_image!.path}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7A9BBF),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                child: Text('Guardar',
                    style: TextStyle(color: Colors.white)),
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
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(fontFamily: 'San Francisco', fontSize: 19),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            fontSize: 18,
            //fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 75, 75, 75)),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFA500), width: 2.0),
          //borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}