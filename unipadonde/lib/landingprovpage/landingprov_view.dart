import 'package:flutter/material.dart';
import 'package:unipadonde/landingprovpage/landingprov_vm.dart';
import 'package:unipadonde/repository/supabase.dart';
import 'package:unipadonde/widgets/bottom_barProv.dart';
import 'package:unipadonde/businessprovinfo/business_info_view.dart';
import 'package:unipadonde/validations.dart'; // Importa el archivo de validaciones

class LandingProv extends StatefulWidget {
  final int userId;

  const LandingProv({required this.userId, super.key});

  @override
  State<LandingProv> createState() => _LandingProvState();
}

class _LandingProvState extends State<LandingProv> {
  late LandingProvVM _viewModel;

  //final dataService = DataService(Supabase.instance.client);

  // Controladores para el formulario de añadir negocio
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _rifController = TextEditingController();

  List<DropdownMenuItem<String>> categoryItems = [];
  String selectedCategory = 'Servicios';
  // Variables para las validaciones
  String? _nameError;
  String? _rifError;
  String? _descriptionError;
  String? _instagramError;
  String? _emailError;
  String? _tiktokError;
  String? _websiteError;
  String _riftype = 'J'; // Valor por defecto

  @override
  void initState() {
    super.initState();
    selectedCategory = 'Servicios';
    categoryItems = [
      DropdownMenuItem(
        value: 'Servicios',
        child: Text('Servicios', style: TextStyle(fontFamily: 'San Francisco')),
      ),
      DropdownMenuItem(
        value: 'Salud y Bienestar',
        child: Text('Salud y Bienestar',
            style: TextStyle(fontFamily: 'San Francisco')),
      ),
      DropdownMenuItem(
        value: 'Comida',
        child: Text('Comida', style: TextStyle(fontFamily: 'San Francisco')),
      ),
      DropdownMenuItem(
        value: 'Entretenimiento',
        child: Text('Entretenimiento',
            style: TextStyle(fontFamily: 'San Francisco')),
      ),
      DropdownMenuItem(
        value: 'Hotelería',
        child: Text('Hotelería', style: TextStyle(fontFamily: 'San Francisco')),
      ),
      DropdownMenuItem(
        value: 'Transporte',
        child:
            Text('Transporte', style: TextStyle(fontFamily: 'San Francisco')),
      ),
    ];
    _viewModel = LandingProvVM(idproveedor: widget.userId);
    fetchBusinesses();
    // Agregar listeners a los controladores para validar en tiempo real
    _nameController.addListener(() {
      _validateName(_nameController.text);
    });
    _rifController.addListener(() {
      _validateRIFNumber(_rifController.text);
    });
    _descriptionController.addListener(() {
      _validateDescription(_descriptionController.text);
    });
    _instagramController.addListener(() {
      _validateInstagram(_instagramController.text);
    });
    _emailController.addListener(() {
      _validateEmail(_emailController.text);
    });
    _tiktokController.addListener(() {
      _validateTikTok(_tiktokController.text);
    });
    _websiteController.addListener(() {
      _validateWebsite(_websiteController.text);
    });
    _viewModel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _nameController.dispose();
    _rifController.dispose();
    _descriptionController.dispose();
    _instagramController.dispose();
    _emailController.dispose();
    _tiktokController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  // Métodos para validar los campos en tiempo real
  void _validateName(String value) {
    setState(() {
      _nameError = Validations.validateNotEmpty(value, "Nombre del negocio");
    });
  }

  void _validateRIFNumber(String value) {
    setState(() {
      _rifError = Validations.validateRIFNumber(value);
    });
  }

  void _validateDescription(String value) {
    setState(() {
      _descriptionError = Validations.validateNotEmpty(value, "Descripción");
    });
  }

  void _validateInstagram(String value) {
    setState(() {
      _instagramError = Validations.validateNotEmpty(value, "Instagram");
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _emailError = Validations.validateEmail(value);
    });
  }

  void _validateTikTok(String value) {
    setState(() {
      _tiktokError = Validations.validateNotEmpty(value, "TikTok");
    });
  }

  void _validateWebsite(String value) {
    setState(() {
      _websiteError = Validations.validateNotEmpty(value, "Página web");
    });
  }

  void logout() async {
    AuthenticationService authService = AuthenticationService();
    await authService.singOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/start');
    }
  }

  Future<void> fetchBusinesses() async {
    _viewModel.fetchBusiness();
  }

  Future<bool> addBusiness(Map<String, dynamic> json) async {
    return await _viewModel.addBusiness(json);
  }

  int _selectedIndex = 0;

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/favsbusiness',
            arguments: widget.userId);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profileprov',
            arguments: widget.userId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            "Mis Negocios",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'San Francisco',
            ),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout, color: Colors.black)),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF8CB1F1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _viewModel.isLoading()
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _viewModel.businesses.length,
                      itemBuilder: (context, index) {
                        final business = _viewModel.businesses[index];
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              leading: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                    image: business.imageurl.isNotEmpty
                                        ? NetworkImage(business
                                            .imageurl) // Network image if URL is available
                                        : AssetImage(business.picture)
                                            as ImageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              title: Text(
                                business.name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'San Francisco'),
                              ),
                              subtitle: Text(
                                business.description,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'San Francisco'),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BusinessInfoView(
                                      business: business,
                                      onBusinessDeleted:
                                          fetchBusinesses, // Pasa la función de actualización
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    showAddBusinessDialog();
                  },
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBarProv(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigateToPage(index);
        },
      ),
    );
  }

  Future showAddBusinessDialog() => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Text(
                        "Añadir Negocio",
                        style: TextStyle(
                            fontFamily: "San Francisco",
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      _buildTextFieldContainer(
                        controller: _nameController,
                        labelText: 'Nombre del negocio',
                        errorText: _nameError,
                      ),

                      const SizedBox(height: 20),
                      // Dropdown para riftype
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFFFFA500),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton<String>(
                            value: _riftype,
                            onChanged: (String? newValue) {
                              setStateDialog(() {
                                _riftype = newValue!;
                              });
                            },
                            items: <String>['J', 'G']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            underline: SizedBox(), // Elimina la línea inferior
                            hint: Text('Seleccione el tipo de RIF'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      _buildTextFieldContainer(
                        controller: _rifController,
                        labelText: 'RIF',
                        errorText: _rifError,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFieldContainer(
                        controller: _descriptionController,
                        maxLines: 6,
                        labelText: 'Descripción',
                        errorText: _descriptionError,
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      ),
                      const SizedBox(height: 20),
                      _buildTextFieldContainer(
                        controller: _instagramController,
                        labelText: 'Instagram',
                        errorText: _instagramError,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFieldContainer(
                        controller: _emailController,
                        labelText: 'Correo electrónico',
                        errorText: _emailError,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFieldContainer(
                        controller: _tiktokController,
                        labelText: 'TikTok',
                        errorText: _tiktokError,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFieldContainer(
                        controller: _websiteController,
                        labelText: 'Página web',
                        errorText: _websiteError,
                      ),
                      const SizedBox(height: 20),
                      _buildDropdownContainer(
                        labelText: 'Categoría',
                        selectedItem: selectedCategory,
                        items: categoryItems,
                        onChanged: (newCategory) {
                          setStateDialog(() {
                            selectedCategory = newCategory!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          // Validar los campos antes de proceder
                          setStateDialog(() {
                            _nameError = Validations.validateNotEmpty(
                                _nameController.text, "Nombre del negocio");
                            _rifError = Validations.validateRIFNumber(
                                _rifController.text);
                            _descriptionError = Validations.validateNotEmpty(
                                _descriptionController.text, "Descripción");
                            _instagramError = Validations.validateNotEmpty(
                                _instagramController.text, "Instagram");
                            _emailError = Validations.validateEmail(
                                _emailController.text);
                            _tiktokError = Validations.validateNotEmpty(
                                _tiktokController.text, "TikTok");
                            _websiteError = Validations.validateNotEmpty(
                                _websiteController.text, "Página web");
                          });

                          // Si no hay errores, proceder con la inserción
                          if (_nameError == null &&
                              _rifError == null &&
                              _descriptionError == null &&
                              _instagramError == null &&
                              _emailError == null &&
                              _tiktokError == null &&
                              _websiteError == null) {
                            try {
                              Map<String, dynamic> negocioData = {
                                'id': _rifController.text,
                                'name': _nameController.text,
                                'picture': 'assets/images/notfound.png',
                                'description': _descriptionController.text,
                                'instagram': _instagramController.text,
                                'mail': _emailController.text,
                                'tiktok': _tiktokController.text,
                                'webpage': _websiteController.text,
                                'id_proveedor': widget.userId,
                                'riftype': _riftype,
                              };

                              if (mounted) {
                                Navigator.of(context).pop();
                              }

                              final response = await addBusiness(negocioData);
                              if (response) {
                                _showSuccessPopup(
                                    'Negocio añadido correctamente.');
                              }

                              // Limpia los controladores
                              _nameController.clear();
                              _descriptionController.clear();
                              _instagramController.clear();
                              _emailController.clear();
                              _tiktokController.clear();
                              _websiteController.clear();
                            } catch (e) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFA500),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Añadir",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "San Francisco"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

//! POP UP DE ÉXITO
  void _showSuccessPopup(String message) {
    showDialog(
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
            message,
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
            ),
          ],
        );
      },
    );
  }

  // Widget para la estética de los textfields con validaciones
  Widget _buildTextFieldContainer({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 10),
    String? errorText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelStyle: TextStyle(fontSize: 20, color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8CB1F1), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFA500), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: contentPadding,
          errorText: errorText,
        ),
      ),
    );
  }

  Widget _buildDropdownContainer({
    required String labelText,
    required List<DropdownMenuItem<String>> items,
    required String selectedItem,
    required ValueChanged<String?> onChanged,
    EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 10),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelStyle: TextStyle(fontSize: 20, color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8CB1F1), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFA500), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: contentPadding,
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
