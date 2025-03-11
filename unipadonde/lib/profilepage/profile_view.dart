import 'package:flutter/material.dart';
import 'package:unipadonde/main.dart';
import 'package:unipadonde/repository/supabase.dart';
import 'package:unipadonde/widgets/bottom_bar.dart';
import 'package:flutter/scheduler.dart';
import 'package:unipadonde/profilepage/components/avatar.dart';

class AuthenticationService {
  final supabaseClient = supabase;
  // Método para obtener los datos del usuario desde la tabla "usuario"
  Future<Map<String, dynamic>> getUserData(int userId) async {
    final response =
        await supabaseClient.from('usuario').select().eq('id', userId).single();
    return response;
  }

  // Método para obtener los datos del estudiante desde la tabla "estudiante"
  Future<Map<String, dynamic>> getStudentData(int userId) async {
    final response = await supabaseClient
        .from('estudiante')
        .select()
        .eq('id', userId)
        .single();
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

  // Método para cerrar sesión
  Future<void> singOut() async {
    await supabaseClient.auth.signOut();
  }
}

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({required this.userId, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthenticationService authService = AuthenticationService();

  String previousName = "";
  String previousLastName = "";
  String previousSex = "";
  String previousEmail = "";
  String previousUniversity = "";
  String _imageUrl = "";
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userData = await authService.getUserData(widget.userId);
    final studentData = await authService.getStudentData(widget.userId);

    setState(() {
      previousName = userData['name'];
      previousLastName = userData['lastname'];
      previousSex = userData['sex'];
      previousEmail = userData['mail'];
      previousUniversity = studentData['universidad'];
      _imageUrl = userData['image_url'];
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
    TextEditingController emailController = TextEditingController();
    TextEditingController universityController = TextEditingController();

    // Lista de opciones para el DropdownMenu
    List<String> genderOptions = ['Femenino', 'Masculino'];

    // Valor seleccionado en el DropdownMenu
    String selectedGender = previousSex == 'F' ? 'Femenino' : 'Masculino';

    nameController.text = previousName;
    lastNameController.text = previousLastName;
    emailController.text = previousEmail;
    universityController.text = previousUniversity;

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
              // Campos del formulario...
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style:
                    TextStyle(fontFamily: 'San Francisco', color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Convertir la selección del DropdownMenu a "F" o "M"
                String sex = selectedGender == 'Femenino' ? 'F' : 'M';

                await authService.updateUserData(widget.userId, {
                  'name': nameController.text,
                  'lastname': lastNameController.text,
                  'sex': sex,
                  'mail': emailController.text,
                });
                setState(() {
                  previousName = nameController.text;
                  previousLastName = lastNameController.text;
                  previousSex = sex;
                  previousEmail = emailController.text;
                  previousUniversity = universityController.text;
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
                style:
                    TextStyle(fontFamily: 'San Francisco', color: Colors.black),
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
                  Avatar(
                      imageUrl: _imageUrl,
                      onUpload: (imageUrl) async {
                        setState(() {
                          _imageUrl = imageUrl;
                        });
                        final userId = supabase.auth.currentUser!.id;
                        await supabase
                            .from('usuario')
                            .update({'image_url': imageUrl}).eq('uid', userId);
                      }),
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
                          'Apellido: $previousLastName',
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sexo: ${previousSex == 'F' ? 'Femenino' : 'Masculino'}',
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
                          'Universidad: $previousUniversity',
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
}
