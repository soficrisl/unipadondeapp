import 'package:flutter/material.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_model.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_vm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:unipadonde/widgets/bottom_bar.dart';
import 'package:unipadonde/widgets/bottom_barProv.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CDiscountPage extends StatefulWidget {
  final int userId;

  const CDiscountPage({required this.userId, super.key});

  @override
  State<CDiscountPage> createState() => _FavspageState();
}

class _FavspageState extends State<CDiscountPage> {
  final DiscountViewModel discountViewModel = DiscountViewModel();

  // Variables para el formulario de añadir negocio
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _idBusinessController = TextEditingController();

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
            Container(
              //margin: const EdgeInsets.only(top: 15.0),
              height: 50,
              color: Color.fromARGB(255, 72, 128, 188),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Descuentos",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'San Francisco',
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            // Botón para añadir un negocio
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showAddDiscountDialog();
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
                child: Text(
                  "Añadir Descuento",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "San Francisco"),
                ),
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

  // Método para mostrar el formulario de añadir descuento
  Future showAddDiscountDialog() => showDialog(
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
                  "Añadir Descuento",
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
                  decoration:
                      InputDecoration(labelText: 'Nombre del descuento:'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción:'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _percentageController,
                  decoration:
                      InputDecoration(labelText: 'Porcentaje de descuento:'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2100),
                      onConfirm: (date) {
                        setState(() {
                          _startDateController.text = date.toIso8601String();
                        });
                      },
                    );
                  },
                  child: Text("Seleccionar Fecha de Inicio"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Muestra el selector de fecha de fin
                    DateTime? selectedEndDate =
                        await DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2100),
                    );
                    if (selectedEndDate != null) {
                      setState(() {
                        _endDateController.text = selectedEndDate.toString();
                      });
                    }
                  },
                  child: Text("Seleccionar Fecha de Fin"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _idBusinessController,
                  decoration: InputDecoration(labelText: 'ID del negocio:'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _addDiscountToDatabase();
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

  Future<void> _addDiscountToDatabase() async {
    DiscountViewModel discountViewModel = DiscountViewModel();
    try {
      // Convierte las fechas a DateTime
      DateTime startDate = DateTime.parse(_startDateController.text);
      DateTime endDate = DateTime.parse(_endDateController.text);

      // Determina el valor de 'state' basado en si la fecha de inicio es hoy
      bool state = startDate.isBefore(DateTime.now()) ||
          startDate.isAtSameMomentAs(DateTime.now());

      // Crear el objeto Discount
      Discount discount = Discount(
        name: _nameController.text,
        description: _descriptionController.text,
        porcentaje: int.parse(_percentageController.text),
        startdate: startDate,
        enddate: endDate,
        state: state,
        id_negocio: int.parse(_idBusinessController.text),
      );

      // Llamar al ViewModel
      bool success = await discountViewModel.addDiscount(discount);

      if (success) {
        _showSuccessPopup(); // Llamar al pop-up de éxito
      } else {
        throw Exception('Error al añadir el descuento');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir descuento: $e')),
      );
    }
  }

  // Función para mostrar el pop-up de éxito y cerrar el formulario
  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Éxito!"),
          content: Text("El descuento se ha añadido correctamente."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el pop-up
                Navigator.of(context)
                    .pop(); // Cierra la pantalla de añadir descuento
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
