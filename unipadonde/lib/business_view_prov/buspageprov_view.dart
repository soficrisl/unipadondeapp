import 'package:flutter/material.dart';
import 'package:unipadonde/business_view_prov/buspageprov_vm.dart';
import 'package:unipadonde/validations.dart';
import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/widgets/avatar_components/avatar_view.dart';

class BusinessPageProv extends StatefulWidget {
  final Business business;

  const BusinessPageProv({super.key, required this.business});

  @override
  State<BusinessPageProv> createState() => _BusinessPageProvState();
}

class _BusinessPageProvState extends State<BusinessPageProv> {
  late BuspageProvViewModel _viewModel;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  // Variables para manejar los errores de validación
  String? _nameError;
  String? _descriptionError;
  String? _tiktokError;
  String? _instagramError;
  String? _websiteError;
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    _viewModel = BuspageProvViewModel(business: widget.business);
    nameController.text = _viewModel.business.name;
    descriptionController.text = _viewModel.business.description;
    tiktokController.text = _viewModel.business.tiktok;
    instagramController.text = _viewModel.business.instagram;
    websiteController.text = _viewModel.business.webpage;
    _imageUrl = _viewModel.business.imageurl;

    // Agregar listeners para validar en tiempo real
    nameController.addListener(() {
      _validateName(nameController.text);
    });
    descriptionController.addListener(() {
      _validateDescription(descriptionController.text);
    });
    _viewModel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
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

  Future<void> _updateBusiness() async {
    _validateName(nameController.text);
    _validateDescription(descriptionController.text);

    // Si no hay errores, proceder con la actualización
    if (_nameError == null && _descriptionError == null) {
      try {
        await _viewModel.updateBusiness(
            nameController.text,
            descriptionController.text,
            tiktokController.text,
            instagramController.text,
            websiteController.text,
            widget.business.id);

        if (_viewModel.getUpdated()) {
          await _showUpdateSuccessPopup();
        } else {
          await _showUpdateUnsuccessfulPopup();
        }

        if (mounted) {
          Navigator.of(context).pop(true);
        }
        // Envía "true" como resultado
      } catch (e) {
        throw Exception("Error al actualizar el negocio: $e");
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

  Future<void> _showUpdateUnsuccessfulPopup() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              "¡Lo sentimos!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'San Francisco',
                fontSize: 25,
                color: Color(0xFF8CB1F1),
              ),
            ),
          ),
          content: Text(
            "La información del negocio no se ha actualizado correctamente. \n Vuelve a intentar",
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
              SizedBox(height: 24),
              _imageUrl.isNotEmpty
                  ? AvatarView(
                      imageUrl: _imageUrl,
                      onUpload: (imageUrl) async {
                        setState(() {
                          _imageUrl = imageUrl;
                        });
                      },
                      type: 'b',
                      IdNegocio: widget.business.id,
                    )
                  : AvatarView(
                      imageUrl: _imageUrl,
                      onUpload: (imageUrl) async {
                        setState(() {
                          _imageUrl = imageUrl;
                        });
                      },
                      type: 'b',
                      prepic: _viewModel.business.picture,
                      IdNegocio: widget.business.id,
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
