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
      ),
    );
  }
}

