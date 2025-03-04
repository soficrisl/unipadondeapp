import 'package:flutter/material.dart';
import 'package:unipadonde/favoritespage/favspage_view.dart';
import 'package:unipadonde/favoritespage/favspage_model.dart';


class BusinessPage extends StatelessWidget {
  final String businessName = 'discount.name';
  final String businessDescription = 'discount.description';
  final String businessTiktok = 'discount.tiktok';
  final String businessInstagram = 'discount.instagram';
  final String businessWebsite = 'discount.website';
  final TextStyle titulos = TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 27,
    fontWeight: FontWeight.bold,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DETALLES DE NEGOCIO', style: titulos),
      ),
      body: Padding(
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
                  border: Border.all(color: const Color(0xFF8CB1F1), width: 4.0),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/american.jpg',  // ! AQUÍ ESTÁ PUESTA UNA IMAGEN RANDOM DE LOS ASSETS. FALTA QUE SE VEA LA INFO REAL
                    fit: BoxFit.contain, // Ajusta la imagen dentro del círculo
                  ),
                ),
              ),
            ),
            _buildInfoRow('Nombre del negocio:', businessName),
            SizedBox(height: 16),
            _buildInfoRow('Descripción del negocio:', businessDescription),
            SizedBox(height: 16),
            _buildInfoRow('Tiktok:', businessTiktok),
            SizedBox(height: 16),
            _buildInfoRow('Instagram:', businessInstagram),
            SizedBox(height: 16),
            _buildInfoRow('Página web:', businessWebsite),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(value, style: TextStyle(
            fontSize: 19,
            fontFamily: 'San Francisco'
          )),
        ),
      ],
    );
  }
}
