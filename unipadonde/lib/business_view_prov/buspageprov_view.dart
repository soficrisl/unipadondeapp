import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/business_view_prov/buspageprov_model.dart';

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

  @override
  void initState() {
    super.initState();
    nameController.text = widget.business.name;
    descriptionController.text = widget.business.description;
    tiktokController.text = widget.business.tiktok;
    instagramController.text = widget.business.instagram;
    websiteController.text = widget.business.webpage;
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
    try {
      final client = Supabase.instance.client;
      await client.from('negocio').update({
        'name': nameController.text,
        'description': descriptionController.text,
        'tiktok': tiktokController.text,
        'instagram': instagramController.text,
        'webpage': websiteController.text,
      }).eq('id', widget.business.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Información actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la información: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: descriptionController,
                label: 'Descripción del negocio',
                maxLines: 6,
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
                onPressed: _updateBusiness,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA500),
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
  int maxLines = 1,
}) {
  return FocusScope(
    child: Focus(
      onFocusChange: (hasFocus) {
        setState(() {});
      },
      child: TextField(
        controller: controller,
        style: TextStyle(fontFamily: 'San Francisco', fontSize: 19),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(
            fontSize: 20, // Aumenta el tamaño de la fuente
            fontFamily: 'San Francisco',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFA500), // Naranja para la etiqueta
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
        ),
      ),
    ),
  );
}

}
