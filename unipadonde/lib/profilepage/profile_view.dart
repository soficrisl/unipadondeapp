import 'package:flutter/material.dart';
import 'package:unipadonde/repository/supabase.dart';
import 'package:unipadonde/widgets/bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({required this.userId, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthenticationService();
  String previousName = "Juan Pérez";  // Este valor provendría de la base de datos
  String previousEmail = "juanperez@example.com"; // Este valor provendría de la base de datos
  String previousPhone = "123456789"; // Este valor provendría de la base de datos
  String previousAddress = "Calle Ficticia 123"; // Este valor provendría de la base de datos

  // Cerrar sesión y redirigir a la pantalla de inicio
  void logout() async {
    await authService.singOut();  // Cerrar sesión
    Navigator.pushReplacementNamed(context, '/landing');  // Redirigir a la pantalla de inicio
  }

  int _selectedIndex = 2;

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/landing', arguments: widget.userId);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/favorites', arguments: widget.userId);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile', arguments: widget.userId);
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
                'Nombre Completo',
                style: TextStyle(fontFamily: 'San Francisco', fontSize: 16),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Introduce tu nombre completo',
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
              onPressed: () {
                // Aquí puedes actualizar los valores en la base de datos
                setState(() {
                  previousName = nameController.text;
                  previousEmail = emailController.text;
                  previousPhone = phoneController.text;
                  previousAddress = addressController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar', style: TextStyle(fontFamily: 'San Francisco', color: Colors.black),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 186, 209, 247),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                textStyle: TextStyle(fontSize: 16, fontFamily: 'San Francisco'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
          title: Text('Política de Cookies', style: TextStyle(fontFamily: 'San Francisco',)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Política de Cookies de UnipaDonde\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'San Francisco',),
                ),
                Text(
                  'Utilizamos cookies para mejorar la experiencia del usuario en nuestra aplicación. Las cookies nos ayudan a analizar el tráfico de la web, personalizar el contenido y los anuncios, y ofrecer funciones de redes sociales. Al continuar utilizando nuestra plataforma, aceptas nuestra política de cookies.',
                  textAlign: TextAlign.justify, style: TextStyle(fontFamily: 'San Francisco',),
                ),
                SizedBox(height: 10),
                Text(
                  'Las cookies son pequeños archivos de texto que se almacenan en tu dispositivo y que permiten que la plataforma reconozca tus preferencias y te ofrezca una mejor experiencia. Puedes gestionar tus preferencias de cookies en cualquier momento a través de la configuración de tu dispositivo.',
                textAlign: TextAlign.justify, style: TextStyle(fontFamily: 'San Francisco',),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'San Francisco',),
                ),
                Text(
                  'Al utilizar nuestra plataforma, aceptas los siguientes términos y condiciones:\n\n'
                  '1. El uso de la aplicación es exclusivamente para usuarios mayores de 18 años.\n'
                  '2. Nos reservamos el derecho de modificar los servicios en cualquier momento sin previo aviso.\n'
                  '3. El contenido proporcionado en la plataforma es solo para fines informativos y no garantiza precisión total.\n'
                  '4. El uso indebido de la aplicación puede resultar en la suspensión o eliminación de la cuenta del usuario.\n\n'
                  'Te recomendamos leer estos términos con atención y aceptar nuestras políticas antes de continuar utilizando la plataforma.' 
                  ,style: TextStyle(fontFamily: 'San Francisco',),
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
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200], // Fondo gris claro para la página
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFF8CB1F1),  // Fondo azul
                  child: Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,  // Cámara blanca
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Acción para cambiar la foto de perfil
                },
                child: Text(
                  'Cambiar Foto',
                  style: TextStyle(fontFamily: 'San Francisco', fontSize: 16, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 207, 207, 207),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16, fontFamily: 'San Francisco'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Modificar Datos - Nuevo estilo
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
      bottomNavigationBar: CustomBottomBar(
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
}