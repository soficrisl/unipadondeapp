import 'package:flutter/material.dart';
import 'package:unipadonde/profilepage/profile_vm.dart';
import 'package:unipadonde/widgets/bottom_bar.dart';
import 'package:unipadonde/widgets/avatar_components/avatar_view.dart';

import '../repository/supabase.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({required this.userId, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthenticationService authService = AuthenticationService();
  late ProfileViewModel _viewModel;

  String previousName = "";
  String previousLastName = "";
  String previousSex = "";
  String previousEmail = "";
  String previousUniversity = "";
  String _imageUrl = "";
  int _selectedIndex = 2;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _viewModel = ProfileViewModel(userId: widget.userId);
      _fetchUserData();
    }
    _viewModel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    if (_viewModel.user != null) {
      setState(() {
        previousName = _viewModel.user!.name;
        previousLastName = _viewModel.user!.lastname;
        previousSex = _viewModel.user!.sex;
        previousEmail = _viewModel.user!.mail;
        previousUniversity = _viewModel.user!.universidad!;
        _imageUrl = _viewModel.user!.imageUrl;
      });
    }
  }

  Future<void> _updateData(Map<String, dynamic> data) async {
    final response = await _viewModel.updateUserData(widget.userId, data);
    if (response) {
      if (mounted) {
        Navigator.of(context).pop();
        _showEditSuccessPopup();
      }
    }
  }

  void logout() async {
    await authService.singOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/landing');
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/landing',
            arguments: widget.userId);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/favorites',
            arguments: widget.userId);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile',
            arguments: widget.userId);
        break;
    }
  }

  void _showEditDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    nameController.text = previousName;
    lastNameController.text = previousLastName;
    String selectedSex = previousSex;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: StatefulBuilder(
          builder: (context, setStateDialog) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Text(
                  'Modificar Datos',
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 25),
                _buildTextFieldContainer(
                  controller: nameController,
                  labelText: 'Nombre',
                ),
                SizedBox(height: 20),
                _buildTextFieldContainer(
                  controller: lastNameController,
                  labelText: 'Apellido',
                ),
                SizedBox(height: 20),
                _buildDropdownContainer(
                  labelText: 'Sexo',
                  selectedItem: selectedSex,
                  items: [
                    DropdownMenuItem(
                      value: 'M',
                      child: Text('Masculino',
                          style: TextStyle(fontFamily: 'San Francisco')),
                    ),
                    DropdownMenuItem(
                      value: 'F',
                      child: Text('Femenino',
                          style: TextStyle(fontFamily: 'San Francisco')),
                    ),
                  ],
                  onChanged: (newSex) {
                    setStateDialog(() {
                      selectedSex = newSex!;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _updateData({
                      'name': nameController.text,
                      'lastname': lastNameController.text,
                      'sex': selectedSex,
                    });

                    setState(() {
                      previousName = nameController.text;
                      previousLastName = lastNameController.text;
                      previousSex = selectedSex;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA500),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    textStyle:
                        TextStyle(fontSize: 16, fontFamily: 'San Francisco'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                        fontFamily: 'San Francisco', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditSuccessPopup() {
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
            "Datos actualizados correctamente.",
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
                Navigator.of(context).pop(); // Cierra el diálogo
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

  void _showCookiePolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Política de Cookies',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'San Francisco',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              )),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 20,
                ),
                SizedBox(height: 10),
                Text(
                  'Utilizamos cookies para mejorar la experiencia del usuario en nuestra aplicación. Las cookies nos ayudan a analizar el tráfico de la web, personalizar el contenido y los anuncios, y ofrecer funciones de redes sociales. Al continuar utilizando nuestra plataforma, aceptas nuestra política de cookies.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Las cookies son pequeños archivos de texto que se almacenan en tu dispositivo y que permiten que la plataforma reconozca tus preferencias y te ofrezca una mejor experiencia. Puedes gestionar tus preferencias de cookies en cualquier momento a través de la configuración de tu dispositivo.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cerrar',
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                    color: Color(0xFFFFA500),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
          ],
        );
      },
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Términos de Servicio',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'San Francisco',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 20,
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '1. ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'El uso de la aplicación es exclusivamente para usuarios mayores de 18 años.',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '2. ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Nos reservamos el derecho de modificar los servicios en cualquier momento.',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '3. ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'El contenido proporcionado en la plataforma es solo para fines informativos y no garantiza precisión total.',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '4. ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'El uso indebido de la aplicación puede resultar en la suspensión o eliminación de la cuenta del usuario.',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text:
                              'Te recomendamos leer estos términos con atención y aceptar nuestras políticas antes de continuar utilizando la plataforma.',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(
                      fontFamily: 'San Francisco',
                      color: Color(0xFFFFA500),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            "UnipaDonde",
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
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  AvatarView(
                      imageUrl: _imageUrl,
                      onUpload: (imageUrl) async {
                        setState(() {
                          _imageUrl = imageUrl;
                        });
                      },
                      type: 'u'),
                  SizedBox(height: 20),
                  // Mostrar datos del usuario
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nombre: ',
                                style: TextStyle(
                                    fontFamily: 'San Francisco',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8CB1F1)),
                              ),
                              TextSpan(
                                text: previousName,
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Apellido: ',
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8CB1F1),
                                ),
                              ),
                              TextSpan(
                                text: previousLastName,
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sexo: ',
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8CB1F1),
                                ),
                              ),
                              TextSpan(
                                text: previousSex == 'F'
                                    ? 'Femenino'
                                    : 'Masculino',
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Correo: ',
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8CB1F1),
                                ),
                              ),
                              TextSpan(
                                text: previousEmail,
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Universidad: ',
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8CB1F1),
                                ),
                              ),
                              TextSpan(
                                text: previousUniversity,
                                style: TextStyle(
                                  fontFamily: 'San Francisco',
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Modificar Datos
                  InkWell(
                    onTap: _showEditDialog,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Color(0xFFFFA500),
                        ),
                        title: Text(
                          'Modificar Datos',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  // Política de Cookies
                  InkWell(
                    onTap: _showCookiePolicy,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.cookie,
                          color: Color(0xFFFFA500),
                        ),
                        title: Text(
                          'Política de Cookies',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  // Términos de Servicio
                  InkWell(
                    onTap: () {
                      _showTermsAndConditions(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.description,
                          color: Color(0xFFFFA500),
                        ),
                        title: Text(
                          'Términos de Servicio',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  // Cerrar sesión
                  InkWell(
                    onTap: () {
                      logout();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Color(0xFFFFA500),
                        ),
                        title: Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                _navigateToPage(index);
              },
            ),
          ),
        ],
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

  //Widget para la estetica de TextFields
  Widget _buildTextFieldContainer({
    required TextEditingController controller,
    required String labelText,
    String? errorText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    //required Function(String) onChanged,
    EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 10),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        //onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
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
      ),
    );
  }
}
