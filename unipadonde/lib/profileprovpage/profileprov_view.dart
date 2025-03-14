import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/widgets/bottom_barProv.dart';
import 'package:flutter/scheduler.dart';
import 'package:unipadonde/validations.dart';

class AuthenticationService {
  final SupabaseClient supabaseClient;

  AuthenticationService({required this.supabaseClient});

  // Método para obtener los datos del usuario desde la tabla "usuario"
  Future<Map<String, dynamic>> getUserData(int userId) async {
    final response =
        await supabaseClient.from('usuario').select().eq('id', userId).single();
    return response;
  }

  // Método para actualizar los datos del usuario en la tabla "usuario"
  Future<void> updateUserData(int userId, Map<String, dynamic> data) async {
    try {
      await supabaseClient.from('usuario').update(data).eq('id', userId);
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }

// Método para actualizar la dirección en la tabla "direccion"
  Future<void> updateAddress(int userId, Map<String, dynamic> data) async {
    try {
      await supabaseClient.from('direccion').update(data).eq('user_id', userId);
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  // Método para cerrar sesión
  Future<void> singOut() async {
    await supabaseClient.auth.signOut();
  }
}

class ProfileProvPage extends StatefulWidget {
  final int userId;

  const ProfileProvPage({required this.userId, super.key});

  @override
  State<ProfileProvPage> createState() => _ProfileProvPageState();
}

class _ProfileProvPageState extends State<ProfileProvPage> {
  final authService = AuthenticationService(
    supabaseClient: SupabaseClient(
      'https://atswkwzuztfzaerlpcpc.supabase.co', // Reemplaza con tu URL de Supabase
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0c3drd3p1enRmemFlcmxwY3BjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5MjczNTcsImV4cCI6MjA1MzUwMzM1N30.FzMP9I3qs9aVol2njwWYjFPKJAgtBE-RkcQ-UrinA2A', // Reemplaza con tu clave de Supabase
    ),
  );

  String previousName = "";
  String previousEmail = "";
  String previousSex = "";
  String previousLastName = "";

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userData = await authService.getUserData(widget.userId);

    setState(() {
      previousName = userData['name'];
      previousLastName = userData['lastname'];
      previousEmail = userData['mail'];
      previousSex = userData['sex'];
    });
  }

  void logout() async {
    await authService.singOut();
    Navigator.pushReplacementNamed(context, '/landing');
  }

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

  void _showEditDialog() {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  nameController.text = previousName;
  lastNameController.text = previousLastName;
  String selectedSex = previousSex;

  // Variables para manejar los errores de validación
  String? nameError;
  String? lastNameError;

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
                errorText: nameError,
                onChanged: (_) {
                  setStateDialog(() {
                    nameError = Validations.validateNameOrLastName(
                        nameController.text, "Nombre");
                  });
                },
              ),
              SizedBox(height: 20),
              _buildTextFieldContainer(
                controller: lastNameController,
                labelText: 'Apellido',
                errorText: lastNameError,
                onChanged: (_) {
                  setStateDialog(() {
                    lastNameError = Validations.validateNameOrLastName(
                        lastNameController.text, "Apellido");
                  });
                },
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
                  // Validar los campos antes de proceder
                  setStateDialog(() {
                    nameError = Validations.validateNameOrLastName(
                        nameController.text, "Nombre");
                    lastNameError = Validations.validateNameOrLastName(
                        lastNameController.text, "Apellido");
                  });

                  // Si no hay errores, proceder con la actualización
                  if (nameError == null && lastNameError == null) {
                    await authService.updateUserData(widget.userId, {
                      'name': nameController.text,
                      'lastname': lastNameController.text,
                      'sex': selectedSex,
                    });

                    setState(() {
                      previousName = nameController.text;
                      previousLastName = lastNameController.text;
                      previousSex = selectedSex;
                    });

                    Navigator.of(context).pop(); // Cerrar el diálogo de edición
                    _showEditSuccessPopup(); // Mostrar el popup de éxito
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA500),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  textStyle: TextStyle(fontSize: 16, fontFamily: 'San Francisco'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(fontFamily: 'San Francisco', color: Colors.white),
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
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFF8CB1F1),
                      child: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Acción para cambiar la foto de perfil
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFA500),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        textStyle: TextStyle(
                            fontSize: 16, fontFamily: 'San Francisco'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Text(
                      'Cambiar Foto',
                      style: TextStyle(
                          fontFamily: 'San Francisco',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Mostrar datos del usuario - Proveedor
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
                                  color: Color(0xFF8CB1F1),
                                ),
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
                        leading: Icon(Icons.edit, color: Color(0xFFFFA500)),
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
                        leading: Icon(Icons.cookie, color: Color(0xFFFFA500)),
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
                        leading:
                            Icon(Icons.description, color: Color(0xFFFFA500)),
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
                        leading:
                            Icon(Icons.exit_to_app, color: Color(0xFFFFA500)),
                        title: Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                              fontFamily: 'San Francisco',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFA500)),
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
            child: CustomBottomBarProv(
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
  Function(String)? onChanged,
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
      onChanged: onChanged,
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
