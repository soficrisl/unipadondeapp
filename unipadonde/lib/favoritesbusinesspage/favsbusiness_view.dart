import 'package:flutter/material.dart';
import 'package:unipadonde/business%20page/buspage_view.dart';
import 'package:unipadonde/favoritespage/favspage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:unipadonde/widgets/bottom_bar.dart';
import 'package:unipadonde/widgets/bottom_barProv.dart';

class Favsbusinesspage extends StatefulWidget {
  final int userId;

  const Favsbusinesspage({required this.userId, super.key});

  @override
  State<Favsbusinesspage> createState() => _FavspageState();
}

class _FavspageState extends State<Favsbusinesspage> {
  //lista de categorias
  List<Categoria> categories = [];
  List<Discount> listofdiscounts = [];
  List<int> selectedCategories = [];

  final dataService = DataService(Supabase
      .instance.client); //esto antes estaba dentro de c/funcion y lo saque

  //Cargar categorias suscritas
  void getcat() async {
    /// Esto deberia estar en el VM
    await dataService.fetchCategoriasSuscritas(widget.userId);
    setState(() {
      categories = dataService.getCategoriasSuscritas();
    });
    getdis();
  }

  //Cargar descuentos
  void getdis() async {
    // Esto deberia estar en el VM
    await dataService.fetchDiscounts();
    setState(() {
      listofdiscounts = dataService.getDescuentos() ?? [];
    });
  }

  // Variables para el formulario de añadir negocio
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getcat();
  }

  // Función de logout
  void logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/start');
    }
  }

  int _selectedIndex = 1;

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
    //filtrar los  de acuerdo a la categoria seleccionada
    final filterDiscount = listofdiscounts.where((discount) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(discount.idcategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        //appBar con nombre de la app y profile
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
                colors: [
                  const Color(0xFF8CB1F1),
                  Colors.white
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                SizedBox(height: 5,),

                // Aqui se maneja la visualización de los negocios 
                Expanded(
                  child: ListView.builder(
                    itemCount: filterDiscount.length,
                    itemBuilder: (context, index) {
                      final discount = filterDiscount[index];
                      return Card(
                        elevation: 4.0,
                        margin:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                  image: AssetImage(discount.businessLogo), //negocio.logo
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            title: Text(
                              discount.name, //negocio.name
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'San Francisco'),
                            ),
                            subtitle: Text(
                              discount.description, //negocio.description
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'San Francisco'),
                            ),
                            onTap: () {
                              BuspageView(); //conexion xon business page (OJO CHECK)
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Botón para añadir un negocio
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showAddBusinessDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFA500), // Color de fondo
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
                    child: Text("Añadir Negocio", style: TextStyle(color: Colors.white, fontFamily: "San Francisco"),),
                  ),
                )
              ],
            ),
            
          ),
          
          //botombar
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

  // Método para mostrar el formulario de añadir negocio
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
                  textAlign: TextAlign.right
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre del negocio:'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción del negocio:'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'Id del negocio:'),
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
                  decoration: InputDecoration(labelText: 'TikTok:',),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _websiteController,
                  decoration: InputDecoration(labelText: 'Página web:'),
                ),
                const SizedBox(height: 20),
              
                ElevatedButton(
                  onPressed: () {
                    // Añadir el negocio a la lista de negocios
                    //final newBusiness = Negocio(
                      //name: _nameController.text,
                      //description: _descriptionController.text,
                      //instagram: _instagramController.text,
                    //);
                    setState(() {
                      //businesses.add(newBusiness);
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8CB1F1), // Color de fondo
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

                child: Text("Añadir", style: TextStyle(color: Colors.white, fontFamily: "San Francisco" ),),
                ),
              ],
            ),
          ),
        ),
      );


  //pop-up con información del negocio
  //Future openDialog(Discount discount) => showDialog(
        //context: context,
        //builder: (context) => Dialog(
          //shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(20),
          //),
          //child: Padding(
            //padding: const EdgeInsets.all(16),
            //child: 
                //Titulo / Nombre de descuento
                //Text(
                  //Negocio(id: id, name: name, description: description, tiktok: tiktok, instagram: instagram, webpage: webpage, mail: mail).name,
                  //"Negocio ",
                  //style: TextStyle(
                    //fontSize: 24,
                    //fontWeight: FontWeight.bold,
                    //color: Colors.black87,
                  //),
                  //textAlign: TextAlign.center,
                //),

            //),
        //)
      //);
}
