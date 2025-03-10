import 'package:flutter/material.dart';
import 'package:unipadonde/business_view_prov/buspageprov_view.dart';
import 'package:unipadonde/favoritespage/favspage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/widgets/bottom_barProv.dart';
import 'package:unipadonde/business_view_prov/buspageprov_model.dart';
import 'package:unipadonde/businessprovinfo/business_info_view.dart';
import 'dart:math'; // Importa la clase Random

class Favsbusinesspage extends StatefulWidget {
  final int userId;

  const Favsbusinesspage({required this.userId, super.key});

  @override
  State<Favsbusinesspage> createState() => _FavspageState();
}

class _FavspageState extends State<Favsbusinesspage> {
  List<Business> businesses = [];
  bool isLoading = true;

  final dataService = DataService(Supabase.instance.client);

  // Controladores para el formulario de añadir negocio
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBusinesses();
  }

  Future<void> fetchBusinesses() async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('negocio')
          .select('*')
          .eq('id_proveedor', widget.userId);

      setState(() {
        businesses = List<Map<String, dynamic>>.from(response)
            .map((json) => Business.fromJson(json))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching businesses: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Genera un ID único para el negocio
  Future<int> generateUniqueId() async {
    final client = Supabase.instance.client;
    final random = Random();
    int id;

    // Genera un ID aleatorio y verifica que no exista en la tabla
    do {
      id = random
          .nextInt(1000000); // Genera un número aleatorio entre 0 y 999999
      final response =
          await client.from('negocio').select('id').eq('id', id).maybeSingle();

      // Si no hay respuesta, el ID no existe y es válido
      if (response == null) {
        break;
      }
    } while (true);

    return id;
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/start');
    }
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
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              setState(() {
                _selectedIndex = 3;
              });
              _navigateToPage(3);
            },
          ),
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
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: businesses.length,
                      itemBuilder: (context, index) {
                        final business = businesses[index];
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
                                    image: AssetImage(business.picture),
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
              child: ElevatedButton(
                onPressed: () {
                  showAddBusinessDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA500),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                  "Añadir Negocio",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "San Francisco"),
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
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                  ),
                  textAlign: TextAlign.center,
                ),
                Text("Ingresa los siguientes datos:",
                    style: TextStyle(
                      fontFamily: "San Francisco",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre del negocio:'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  decoration:
                      InputDecoration(labelText: 'Descripción del negocio:'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _instagramController,
                  decoration: InputDecoration(labelText: 'Instagram:'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Correo electrónico:'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _tiktokController,
                  decoration: InputDecoration(
                    labelText: 'TikTok:',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _websiteController,
                  decoration: InputDecoration(labelText: 'Página web:'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text;
                    final description = _descriptionController.text;
                    final instagram = _instagramController.text;
                    final email = _emailController.text;
                    final tiktok = _tiktokController.text;
                    final webpage = _websiteController.text;

                    if (name.isEmpty ||
                        description.isEmpty ||
                        instagram.isEmpty ||
                        email.isEmpty ||
                        tiktok.isEmpty ||
                        webpage.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Por favor, completa todos los campos.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      final client = Supabase.instance.client;

                      // Genera un ID único para el negocio
                      final id = await generateUniqueId();

                      // Inserta el nuevo negocio en la tabla
                      await client.from('negocio').insert({
                        'id': id, // Usa el ID generado
                        'name': name,
                        'picture':
                            'assets/images/notfound.png', // Valor predeterminado para la imagen
                        'description': description,
                        'instagram': instagram,
                        'mail': email,
                        'tiktok': tiktok,
                        'webpage': webpage,
                        'id_proveedor': widget.userId,
                        'riftype': 'J', // Valor fijo
                      });

                      // Cierra el diálogo antes de mostrar el SnackBar
                      Navigator.of(context).pop();

                      // Muestra el SnackBar después de cerrar el diálogo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Negocio añadido correctamente.'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Limpia los controladores
                      _nameController.clear();
                      _descriptionController.clear();
                      _instagramController.clear();
                      _emailController.clear();
                      _tiktokController.clear();
                      _websiteController.clear();

                      // Actualiza la lista de negocios
                      fetchBusinesses();
                    } catch (e) {
                      // Cierra el diálogo antes de mostrar el SnackBar de error
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al añadir el negocio: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8CB1F1),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
}
