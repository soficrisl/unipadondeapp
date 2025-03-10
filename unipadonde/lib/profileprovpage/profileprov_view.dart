import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/widgets/bottom_barProv.dart';
import 'package:flutter/scheduler.dart';

class AuthenticationService {
  final SupabaseClient supabaseClient;

  AuthenticationService({required this.supabaseClient});

  // Método para obtener los datos del usuario desde la tabla "usuario"
  Future<Map<String, dynamic>> getUserData(int userId) async {
    final response = await supabaseClient
        .from('usuario')
        .select()
        .eq('id', userId)
        .single();
    return response;
  }


  // Método para actualizar los datos del usuario en la tabla "usuario"
  Future<void> updateUserData(int userId, Map<String, dynamic> data) async {
    try {
      await supabaseClient
          .from('usuario')
          .update(data)
          .eq('id', userId);
    } catch (e) {
      throw Exception('Error updating user data: $e');
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
  String previousPhone = "";
  String previousAddress = "";

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
      previousEmail = userData['mail'];

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
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  nameController.text = previousName;
  emailController.text = previousEmail;
  phoneController.text = previousPhone;
  addressController.text = previousAddress;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 215, 228, 252),
        title: Text(
          'Modificar Datos',
          style: TextStyle(
            fontFamily: 'San Francisco',
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nombre',
              style: TextStyle(fontFamily: 'San Francisco', fontSize: 16),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Introduce tu nombre',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Correo Electrónico',
              style: TextStyle(fontFamily: 'San Francisco', fontSize: 16),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Introduce tu correo electrónico',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Teléfono',
              style: TextStyle(fontFamily: 'San Francisco', fontSize: 16),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: 'Introduce tu teléfono',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Dirección',
              style: TextStyle(fontFamily: 'San Francisco', fontSize: 16),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Introduce tu dirección',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(fontFamily: 'San Francisco', color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Actualizar los datos en Supabase
              await authService.updateUserData(widget.userId, {
                'name': nameController.text,
                'mail': emailController.text,
              });

              setState(() {
                previousName = nameController.text;
                previousEmail = emailController.text;
                previousPhone = phoneController.text;
                previousAddress = addressController.text;
              });

              Navigator.of(context).pop();

              // Usar SchedulerBinding para mostrar el SnackBar después del frame actual
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Información actualizada exitosamente',
                      style: TextStyle(fontFamily: 'San Francisco'),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 186, 209, 247),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              textStyle: TextStyle(fontSize: 16, fontFamily: 'San Francisco'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Guardar',
              style: TextStyle(fontFamily: 'San Francisco', color: Colors.black),
            ),
          ),
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
              style: TextStyle(
                fontFamily: 'San Francisco',
              )),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Política de Cookies de UnipaDonde\n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'San Francisco',
                  ),
                ),
                Text(
                  'Utilizamos cookies para mejorar la experiencia del usuario en nuestra aplicación. Las cookies nos ayudan a analizar el tráfico de la web, personalizar el contenido y los anuncios, y ofrecer funciones de redes sociales. Al continuar utilizando nuestra plataforma, aceptas nuestra política de cookies.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Las cookies son pequeños archivos de texto que se almacenan en tu dispositivo y que permiten que la plataforma reconozca tus preferencias y te ofrezca una mejor experiencia. Puedes gestionar tus preferencias de cookies en cualquier momento a través de la configuración de tu dispositivo.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y Condiciones'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Términos y Condiciones de UnipaDonde\n\n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'San Francisco',
                  ),
                ),
                Text(
                  'Al utilizar nuestra plataforma, aceptas los siguientes términos y condiciones:\n\n'
                  '1. El uso de la aplicación es exclusivamente para usuarios mayores de 18 años.\n'
                  '2. Nos reservamos el derecho de modificar los servicios en cualquier momento sin previo aviso.\n'
                  '3. El contenido proporcionado en la plataforma es solo para fines informativos y no garantiza precisión total.\n'
                  '4. El uso indebido de la aplicación puede resultar en la suspensión o eliminación de la cuenta del usuario.\n\n'
                  'Te recomendamos leer estos términos con atención y aceptar nuestras políticas antes de continuar utilizando la plataforma.',
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
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
                      backgroundColor: const Color.fromARGB(255, 207, 207, 207),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      textStyle: TextStyle(fontSize: 16, fontFamily: 'San Francisco'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cambiar Foto',
                      style: TextStyle(
                          fontFamily: 'San Francisco',
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Mostrar datos del usuario
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre: $previousName',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Correo: $previousEmail',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Teléfono: $previousPhone',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Dirección: $previousAddress',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
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
                        leading: Icon(Icons.edit),
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
                        leading: Icon(Icons.cookie),
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
                    onTap: _showTermsAndConditions,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.description),
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
                        leading: Icon(Icons.exit_to_app),
                        title: Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
}