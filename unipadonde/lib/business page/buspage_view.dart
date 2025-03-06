import 'package:flutter/material.dart';

class BuspageView extends StatelessWidget {
  final String businessName;
  final String businessDescription;
  final String businessTiktok;
  final String businessInstagram;
  final String businessWebsite;
  final String businessLogo;

  final TextStyle titulos = TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 27,
    fontWeight: FontWeight.bold,
  );

  BuspageView({
    required this.businessName,
    required this.businessDescription,
    required this.businessTiktok,
    required this.businessInstagram,
    required this.businessWebsite,
    required this.businessLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90, // Altura del AppBar
        elevation: 0, // Sin sombra
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
              color: Colors.white, // Texto en blanco
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'San Francisco',
            ),
          ),
        ),
        backgroundColor: Colors.white, // Fondo blanco para el AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8CB1F1), // Color inicial del gradiente
              Colors.white, // Color final del gradiente
            ],
            begin: Alignment.topCenter, // Inicia desde la parte superior
            end: Alignment.bottomCenter, // Termina en la parte inferior
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFFFA500), width: 4.0),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      businessLogo, // Usa la imagen del negocio
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio después de la imagen
              _buildInfoRow('Nombre del negocio:', businessName),
              _buildInfoRow('Descripción del negocio:', businessDescription),
              _buildInfoRow('Tiktok:', businessTiktok),
              _buildInfoRow('Instagram:', businessInstagram),
              _buildInfoRow('Página web:', businessWebsite),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4), // Espacio entre el título y la información
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontFamily: 'San Francisco',
          ),
        ),
        SizedBox(height: 16), // Espacio entre cada sección
      ],
    );
  }
}