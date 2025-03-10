import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/business_view_prov/buspageprov_view.dart';
import 'package:unipadonde/business_view_prov/buspageprov_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BusinessInfoView extends StatefulWidget {
  final Business business;
  final VoidCallback onBusinessDeleted; // Función de actualización

  const BusinessInfoView({
    required this.business,
    required this.onBusinessDeleted, // Acepta la función de actualización
  });

  @override
  _BusinessInfoViewState createState() => _BusinessInfoViewState();
}

class _BusinessInfoViewState extends State<BusinessInfoView> {
  List<Map<String, dynamic>> discounts = [];
  Map<String, dynamic>? address;
  bool isLoading = true;
  Business currentBusiness; // Mantén una copia local del negocio

  _BusinessInfoViewState() : currentBusiness = Business(
    id: 0,
    name: '',
    description: '',
    picture: '',
    tiktok: '',
    instagram: '',
    webpage: '',
  );

  @override
  void initState() {
    super.initState();
    currentBusiness = widget.business; // Inicializa con el negocio recibido
    fetchDiscounts(); // Llama a fetchDiscounts al iniciar
    fetchAddress(); // Llama a fetchAddress al iniciar
  }

  // Método para obtener los descuentos del negocio
  Future<void> fetchDiscounts() async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('descuento')
          .select('*')
          .eq('id_negocio', currentBusiness.id);

      setState(() {
        discounts = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching discounts: $e');
    }
  }

  // Método para obtener la dirección del negocio
  Future<void> fetchAddress() async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('direccion')
          .select('*')
          .eq('id_negocio', currentBusiness.id)
          .single();

      setState(() {
        address = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching address: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para actualizar los datos del negocio
  Future<void> _refreshBusinessData() async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('negocio')
          .select('*')
          .eq('id', currentBusiness.id)
          .single();

      setState(() {
        currentBusiness = Business.fromJson(response);
      });
    } catch (e) {
      print('Error refreshing business data: $e');
    }
  }

  // Método para eliminar el negocio
  Future<void> _deleteBusiness() async {
  try {
    final client = Supabase.instance.client;

    // Elimina el negocio de la base de datos
    await client.from('negocio').delete().eq('id', currentBusiness.id);

    // Muestra un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Negocio eliminado correctamente.'),
        backgroundColor: Colors.green,
      ),
    );

    // Llama a la función de actualización
    widget.onBusinessDeleted();

    // Navega de regreso a la pantalla anterior
    Navigator.of(context).pop();
  } catch (e) {
    // Muestra un mensaje de error si algo sale mal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al eliminar el negocio: $e'),
        backgroundColor: Colors.red,
      ),
    );
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
            'Detalles del negocio',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'San Francisco',
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFFFA500), width: 4.0),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        currentBusiness.picture,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      currentBusiness.name,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'San Francisco',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                currentBusiness.description,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'San Francisco',
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Tiktok', currentBusiness.tiktok, 'assets/icons/tiktok.png'),
                        _buildInfoRow('Instagram', currentBusiness.instagram, 'assets/icons/instagram.png'),
                        _buildInfoRow('Página web', currentBusiness.webpage, 'assets/icons/sitio-web.png'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (address != null) ...[
                          _buildInfoRow('Estado', address!['estado'], ''),
                          _buildInfoRow('Ciudad', address!['ciudad'], ''),
                          _buildInfoRow('Municipio', address!['municipio'], ''),
                          _buildInfoRow('Calle', address!['calle'], ''),
                          if (address!['additional_info'] != null)
                            _buildInfoRow('Información adicional', address!['additional_info'], ''),
                        ] else if (isLoading)
                          Center(child: CircularProgressIndicator())
                        else
                          Text('No se encontró la dirección'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (discounts.isEmpty)
                Center(child: Text('No hay descuentos disponibles'))
              else
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    autoPlay: discounts.length > 1,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: discounts.length > 1,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: discounts.length > 1 ? 0.9 : 1.0,
                  ),
                  items: discounts.map((discount) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  discount['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  discount['description'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Descuento: ${discount['porcentaje']}%",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Válido desde: ${discount['startdate']} hasta ${discount['enddate']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Navega a BusinessPageProv y espera el resultado
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BusinessPageProv(business: currentBusiness),
                    ),
                  );

                  // Si el resultado es `true`, actualiza los datos
                  if (result == true) {
                    await _refreshBusinessData();
                    await fetchDiscounts(); // Actualiza los descuentos
                    await fetchAddress(); // Actualiza la dirección
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7A9BBF),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                child: Text('Editar información del negocio',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Muestra un diálogo de confirmación antes de eliminar el negocio
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('Eliminar negocio', style: TextStyle(color: Colors.black, fontFamily: "San Francisco",fontWeight: FontWeight.w800 ),),
                      content: Text('¿Estás seguro de que deseas eliminar este negocio?', style: TextStyle(fontFamily: "San Francisco", fontSize: 18)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancelar',style: TextStyle(fontFamily: "San Francisco", fontSize: 17)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Eliminar', style: TextStyle(fontFamily: "San Francisco", color: Colors.red,fontSize: 17 ),),
                        ),
                      ],
                    ),
                  );

                  // Si el usuario confirma, elimina el negocio
                  if (confirm == true) {
                    await _deleteBusiness();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                child: Text('Eliminar negocio',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String iconPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (iconPath.isNotEmpty)
              Image.asset(
                iconPath,
                width: 24,
                height: 24,
              ),
            if (iconPath.isNotEmpty) SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontFamily: 'San Francisco',
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}