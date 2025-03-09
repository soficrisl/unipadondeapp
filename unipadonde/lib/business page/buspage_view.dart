import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>> comments = []; // Lista de comentarios
  final TextEditingController _commentController = TextEditingController(); // Controlador para el campo de comentario
  int _rating = 0; // Calificación del usuario

  @override
  void initState() {
    super.initState();
    fetchDiscounts(); // Obtener los descuentos al iniciar la página
    fetchAddress(); // Obtener la dirección del negocio
    fetchComments(); // Obtener los comentarios del negocio
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

  //! Método para obtener los comentarios del negocio con el nombre y apellido del usuario
  Future<void> fetchComments() async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('comenta')
          .select('''
            *, 
            estudiante:estudiante(id, usuario:usuario(id, name, lastname))
          ''')
          .eq('id_negocio', widget.idNegocio); // Filtrar por id_negocio

      setState(() {
        comments = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  // ! Método para enviar un comentarioooooooooooooooooooooooooooooo
  Future<void> submitComment() async {
  try {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;

    if (user == null) {
      // Mostrar un mensaje si el usuario no está autenticado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debes iniciar sesión para enviar un comentario.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_commentController.text.isEmpty || _rating == 0) {
      // Mostrar un mensaje si el comentario o la calificación están vacíos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, escribe un comentario y selecciona una calificación.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Obtener el id del usuario como un integer desde la tabla usuario
    final usuarioResponse = await client
        .from('usuario')
        .select('id')
        .eq('uid', user.id) // Usar la columna 'uid' para hacer la relación
        .single();

    final int usuarioId = usuarioResponse['id']; // Asegúrate de que esto sea un integer

    // Obtener el id del estudiante asociado al usuario
    final estudianteResponse = await client
        .from('estudiante')
        .select('id')
        .eq('id', usuarioId) // Usar la columna 'id' en lugar de 'id_usuario'
        .single();

    final int estudianteId = estudianteResponse['id']; // Asegúrate de que esto sea un integer

    // Insertar el comentario
    await client.from('comenta').insert({
      'id_usuario': estudianteId, // Usar el id del estudiante (integer)
      'id_negocio': widget.idNegocio, // integer
      'date': DateTime.now().toIso8601String(),
      'content': _commentController.text,
      'calificacion': _rating,
    });

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comentario recibido.'),
        backgroundColor: Colors.green,
      ),
    );

    // Limpiar el campo de comentario y reiniciar la calificación
    _commentController.clear();
    _rating = 0;

    // Recargar la página actual
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BuspageView(
          businessName: widget.businessName,
          businessDescription: widget.businessDescription,
          businessTiktok: widget.businessTiktok,
          businessInstagram: widget.businessInstagram,
          businessWebsite: widget.businessWebsite,
          businessLogo: widget.businessLogo,
          idNegocio: widget.idNegocio,
        ),
      ),
    );
  } catch (e) {
    // Mostrar un mensaje de error si ocurre una excepción
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
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

              // Sección de comentarios
              Text(
                'Comentarios',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'San Francisco',
                ),
              ),
              SizedBox(height: 10),

              // Formulario para enviar comentarios
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
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: submitComment,
                    child: Text('Enviar comentario'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Lista de comentarios
              // Lista de comentarios
            // Lista de comentarios
            if (comments.isEmpty)
              Text('No hay comentarios aún')
            else
              Column(
                children: comments.map((comment) {
                  final usuario = comment['estudiante']['usuario'];
                  final nombreCompleto = '${usuario['name']} ${usuario['lastname']}';

                  // Obtener la calificación del comentario
                  final calificacion = comment['calificacion'];

                  // Formatear la fecha
                  final fechaOriginal = DateTime.parse(comment['date']); // Convertir a DateTime
                  final fechaFormateada = DateFormat('dd-MM-yyyy').format(fechaOriginal); // Formatear a DD-MM-AAAA

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(nombreCompleto), // Nombre y apellido del usuario
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment['content']), // Contenido del comentario
                          SizedBox(height: 5), // Espacio entre el contenido y las estrellas
                          // Mostrar la calificación como estrellas
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < calificacion ? Icons.star : Icons.star_border,
                                color: Colors.orange, // Color de las estrellas
                                size: 20, // Tamaño de las estrellas
                              );
                            }),
                          ),
                          SizedBox(height: 5), // Espacio adicional
                          Text(fechaFormateada), // Fecha formateada (DD-MM-AAAA)
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