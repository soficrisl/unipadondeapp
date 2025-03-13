import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'buspage_vm.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importar Supabase

class BuspageView extends StatefulWidget {
  final String businessName;
  final String businessDescription;
  final String businessTiktok;
  final String businessInstagram;
  final String businessWebsite;
  final String businessLogo;
  final int idNegocio;

  BuspageView({
    required this.businessName,
    required this.businessDescription,
    required this.businessTiktok,
    required this.businessInstagram,
    required this.businessWebsite,
    required this.businessLogo,
    required this.idNegocio,
  });

  @override
  _BuspageViewState createState() => _BuspageViewState();
}

class _BuspageViewState extends State<BuspageView> {
  final BuspageViewModel _viewModel = BuspageViewModel();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchDiscounts(widget.idNegocio);
    _viewModel.fetchAddress(widget.idNegocio);
    _viewModel.fetchComments(widget.idNegocio);
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

  Future<void> _submitComment() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debes iniciar sesión para enviar un comentario.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_commentController.text.isEmpty || _viewModel.rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, escribe un comentario y selecciona una calificación.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final usuarioResponse = await Supabase.instance.client
          .from('usuario')
          .select('id')
          .eq('uid', user.id)
          .single();

      final int usuarioId = usuarioResponse['id'];

      final estudianteResponse = await Supabase.instance.client
          .from('estudiante')
          .select('id')
          .eq('id', usuarioId)
          .single();

      final int estudianteId = estudianteResponse['id'];

      await _viewModel.submitComment(widget.idNegocio, estudianteId, _commentController.text, _viewModel.rating);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comentario recibido.'),
          backgroundColor: Colors.green,
        ),
      );

      _commentController.clear();
      _viewModel.rating = 0;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatDate(String timestamp) {
  // Convierte el timestamp en un objeto DateTime
  DateTime dateTime = DateTime.parse(timestamp);
  // Define el formato que deseas
  DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  // Devuelve la fecha formateada
  return dateFormat.format(dateTime);
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
              const Color.fromARGB(255, 231, 231, 231),
              const Color.fromARGB(255, 235, 234, 234),
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
                      color: const Color.fromARGB(255, 226, 226, 226),
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
                  Expanded(
                    child: Text(
                      widget.businessName,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'San Francisco',
                        color: Colors.black87,
                        shadows: [
                          Shadow(
                            color:
                                Colors.black.withOpacity(0.1), // Sombra sutil
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                          ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                widget.businessDescription,
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'San Francisco',
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),
              _buildDetailContainer(
                'Tiktok',
                widget.businessTiktok,
                'assets/icons/tiktok.png',
              ),
              SizedBox(height: 10),
              _buildDetailContainer(
                'Instagram',
                widget.businessInstagram,
                'assets/icons/instagram.png',
              ),
              SizedBox(height: 10),
              _buildDetailContainer(
                'Página web',
                widget.businessWebsite,
                'assets/icons/sitio-web.png',
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Direccion:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          if (_viewModel.address != null) ...[
                            Row(
                              children: [
                                Text(
                                  'Estado:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _viewModel.address!['estado'] ?? 'No disponible',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Ciudad:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _viewModel.address!['ciudad'] ?? 'No disponible',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Municipio:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _viewModel.address!['municipio'] ?? 'No disponible',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Calle:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _viewModel.address!['calle'] ?? 'No disponible',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_viewModel.address!['additional_info'] != null) 
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Información adicional:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  _viewModel.address!['additional_info'] ?? 'No disponible',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            )
                          ] else if (_viewModel.isLoading)
                            Center(child: CircularProgressIndicator())
                          else
                            Text(
                              'No se encontró la dirección',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          Text(
                            "value",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              if (_viewModel.isLoading)
                Center(child: CircularProgressIndicator())
              else if (_viewModel.discounts.isEmpty)
                Center(child: Text('No hay descuentos disponibles'))
              else
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    autoPlay: _viewModel.discounts.length > 1,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: _viewModel.discounts.length > 1,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: _viewModel.discounts.length > 1 ? 0.9 : 1.0,
                  ),
                  items: _viewModel.discounts.map((discount) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            // Mostrar diálogo con la información completa del descuento
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  discount['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontFamily: "San Francisco",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 27,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        discount['description'],
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "San Francisco",
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "${discount['porcentaje']}%",
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontFamily: "San Francisco",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 64,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Válido desde: ",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "San Francisco",
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              " ${formatDate(discount['startdate'])}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "San Francisco",
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(255, 97, 97, 97),
                                              ),
                                            ),
                                            Text(
                                              "hasta: ",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "San Francisco",
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              " ${formatDate(discount['enddate'])}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "San Francisco",
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(255, 95, 95, 95),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1), // Reduces the top padding
                                    child: TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text(
                                        'Cerrar',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: "San Francisco",
                                          color: Color.fromARGB(255, 102, 150, 232),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )




                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              height:
                                  230, // Altura definida para ajustar el contenido
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white, // Fondo blanco
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 102, 150, 232), // Borde azul
                                  width: 5.0,
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Stack(
                                children: [
                                  // Contenido del descuento (nombre y descripción)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2), // Espacio para los botones
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Nombre del descuento
                                        Text(
                                          discount['name'],
                                          style: TextStyle(
                                            fontSize:
                                                25, // Tamaño de fuente grande
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 8), // Espaciado
                                        // Descripción del descuento
                                        Text(
                                          discount['description'],
                                          style: TextStyle(
                                            fontSize:
                                                16, // Tamaño de fuente mediano
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              Text(
                'Comentarios',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'San Francisco',
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu comentario...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  Text('Calificación:'),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _viewModel.rating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          _viewModel.rating = index + 1;
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitComment,
                    child: Text('Enviar comentario'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_viewModel.comments.isEmpty)
                Text('No hay comentarios aún')
              else
                Column(
                  children: _viewModel.comments.map((comment) {
                    final usuario = comment['estudiante']['usuario'];
                    final nombreCompleto = '${usuario['name']} ${usuario['lastname']}';
                    final calificacion = comment['calificacion'];
                    final fechaOriginal = DateTime.parse(comment['date']);
                    final fechaFormateada = DateFormat('dd-MM-yyyy').format(fechaOriginal);

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(nombreCompleto),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['content']),
                            SizedBox(height: 5),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < calificacion ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                  size: 20,
                                );
                              }),
                            ),
                            SizedBox(height: 5),
                            Text(fechaFormateada),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir un Container con detalles
  Widget _buildDetailContainer(String title, String value, String iconPath) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (iconPath.isNotEmpty)
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
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