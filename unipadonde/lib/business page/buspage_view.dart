import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importar Supabase

class BuspageView extends StatefulWidget {
  final String businessName;
  final String businessDescription;
  final String businessTiktok;
  final String businessInstagram;
  final String businessWebsite;
  final String businessLogo;
  final int idNegocio; // Nuevo campo: ID del negocio

  BuspageView({
    required this.businessName,
    required this.businessDescription,
    required this.businessTiktok,
    required this.businessInstagram,
    required this.businessWebsite,
    required this.businessLogo,
    required this.idNegocio, // Nuevo campo: ID del negocio
  });

  @override
  _BuspageViewState createState() => _BuspageViewState();
}

class _BuspageViewState extends State<BuspageView> {
  List<Map<String, dynamic>> discounts = []; // Lista de descuentos
  Map<String, dynamic>? address; // Información de la dirección
  bool isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    fetchDiscounts(); // Obtener los descuentos al iniciar la página
    fetchAddress(); // Obtener la dirección del negocio
  }

  // Método para obtener los descuentos del negocio
  Future<void> fetchDiscounts() async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('descuento')
          .select('*')
          .eq('id_negocio', widget.idNegocio); // Filtrar por id_negocio

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
          .eq('id_negocio', widget.idNegocio) // Filtrar por id_negocio
          .single(); // Obtener un solo registro

      setState(() {
        address = response;
        isLoading = false; // Finalizar la carga
      });
    } catch (e) {
      print('Error fetching address: $e');
      setState(() {
        isLoading = false; // Finalizar la carga incluso si hay un error
      });
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
              const Color(0xFFFFA500), // Naranja
              const Color(0xFF7A9BBF), // Azul medio
              const Color(0xFF8CB1F1), // Azul claro
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
              const Color.fromARGB(255, 255, 255, 255), // Color inicial del gradiente
              Colors.white, // Color final del gradiente
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Contenedor para la imagen y el nombre del negocio
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Imagen del negocio
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
                        widget.businessLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Nombre del negocio
                  Expanded(
                    child: Text(
                      widget.businessName,
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

              // Descripción del negocio
              Text(
                widget.businessDescription,
                style: TextStyle(
                  fontSize: 24, // Mismo tamaño de letra que en _buildInfoRow
                  fontFamily: 'San Francisco',
                ),
              ),
              SizedBox(height: 20),

              // Sección dividida en dos columnas
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Redes sociales y página web
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Tiktok', widget.businessTiktok, 'assets/icons/tiktok.png'),
                        _buildInfoRow('Instagram', widget.businessInstagram, 'assets/icons/instagram.png'),
                        _buildInfoRow('Página web', widget.businessWebsite, 'assets/icons/sitio-web.png'),
                      ],
                    ),
                  ),

                  // Columna derecha: Información de la dirección
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

              // Carrusel de descuentos
              if (isLoading)
                Center(child: CircularProgressIndicator()) // Mostrar carga
              else if (discounts.isEmpty)
                Center(child: Text('No hay descuentos disponibles')) // Sin descuentos
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
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir una fila de información con ícono
  Widget _buildInfoRow(String label, String value, String iconPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Mostrar el ícono si se proporciona una ruta
            if (iconPath.isNotEmpty)
              Image.asset(
                iconPath,
                width: 24, // Ajusta el tamaño del ícono según sea necesario
                height: 24,
              ),
            if (iconPath.isNotEmpty) SizedBox(width: 8), // Espacio entre el ícono y el texto
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