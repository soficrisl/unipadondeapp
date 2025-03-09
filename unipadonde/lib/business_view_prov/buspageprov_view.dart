import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BusinessPageProv extends StatefulWidget {
=======
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

<<<<<<< HEAD
=======
  @override
  void initState() {
    super.initState();
    nameController.text = widget.business.name;
    descriptionController.text = widget.business.description;
    tiktokController.text = widget.business.tiktok;
    instagramController.text = widget.business.instagram;
    websiteController.text = widget.business.webpage;
  }

>>>>>>> 04deb0244c1b823ad3b70639ea0770768724156d
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Negocio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                child: _image == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                    : ClipOval(
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del negocio',
                border: OutlineInputBorder(),
                
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción del negocio',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: tiktokController,
              decoration: InputDecoration(
                labelText: 'Tiktok',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: instagramController,
              decoration: InputDecoration(
                labelText: 'Instagram',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: websiteController,
              decoration: InputDecoration(
                labelText: 'Página web',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para guardar los datos ingresados
                print('Nombre: ${nameController.text}');
                print('Descripción: ${descriptionController.text}');
                print('Tiktok: ${tiktokController.text}');
                print('Instagram: ${instagramController.text}');
                print('Página web: ${websiteController.text}');
                if (_image != null) {
                  print('Imagen guardada en: ${_image!.path}');
                }
              },
              child: Text('Guardar'),
            ),
          ],
        ),

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

    // Devuelve `true` para indicar que los datos se han actualizado
    Navigator.of(context).pop(true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al actualizar la información: $e'),
        backgroundColor: Colors.red,
>>>>>>> 04deb0244c1b823ad3b70639ea0770768724156d
      ),
    );
  }
}

<<<<<<< HEAD
=======
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
                onPressed: _updateBusiness,
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
>>>>>>> 04deb0244c1b823ad3b70639ea0770768724156d
