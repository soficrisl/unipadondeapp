/*import 'package:flutter/material.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_model.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_vm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:unipadonde/widgets/bottom_bar.dart';
import 'package:unipadonde/widgets/bottom_barProv.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CDiscountPage extends StatefulWidget {
  final int userId;

  const CDiscountPage({required this.userId, super.key});

  @override
  State<CDiscountPage> createState() => _FavspageState();
}

class _FavspageState extends State<CDiscountPage> {
  final DiscountViewModel discountViewModel = DiscountViewModel();

  // probando cambios
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _idBusinessController = TextEditingController();

  // Variables para las validaciones
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String? _nameError;
  String? _descriptionError;
  String? _percentageError;
  String? _dateError;

  bool _isLoading = false;

  //PRUEBA DATE TIME RANGE PICKER

  Future<void> showDateTimeRangePicker() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    if (dateTimeList != null && dateTimeList.length == 2) {
      setState(() {
        _selectedStartDate = dateTimeList[0];
        _selectedEndDate = dateTimeList[1];

        _startDateController.text =
            "${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year} ${_selectedStartDate!.hour}:${_selectedStartDate!.minute}";
        _endDateController.text =
            "${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year} ${_selectedEndDate!.hour}:${_selectedEndDate!.minute}";
      });
    }
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
            const SizedBox(
              height: 5,
            ),
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
          child: StatefulBuilder(
            builder: (context, setStateDialog) => Padding(
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'San Francisco',
                        color: Color(0xFFFFA500)),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre:',
                      errorText: _nameError,
                    ),
                    style: const TextStyle(fontFamily: 'San Francisco'),
                    onChanged: (_) {
                      setStateDialog(() {
                        _nameError = _nameController.text.isEmpty
                            ? "El nombre no puede estar vacío"
                            : null;
                      });
                    },
                  ),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Descripción:',
                      errorText: _descriptionError,
                    ),
                    style: const TextStyle(fontFamily: 'San Francisco'),
                    onChanged: (_) {
                      setStateDialog(() {
                        _descriptionError = _descriptionController.text.isEmpty
                            ? "La descripción no puede estar vacía"
                            : null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _percentageController,
                    decoration: InputDecoration(
                      labelText: 'Porcentaje:',
                      errorText: _percentageError,
                    ),
                    style: const TextStyle(fontFamily: 'San Francisco'),
                    onChanged: (_) {
                      setStateDialog(() {
                        _percentageError =
                            int.tryParse(_percentageController.text) == null
                                ? "Debe ser un número entero"
                                : null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await showDateTimeRangePicker();
                      setStateDialog(() {
                        _dateError = (_selectedStartDate == null ||
                                _selectedEndDate == null)
                            ? "Debe seleccionar las fechas"
                            : null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFFFFA500), // Cambia aquí a tu color
                      textStyle: const TextStyle(
                          fontFamily: 'San Francisco', color: Colors.white),
                    ),
                    child: Text(
                      _selectedStartDate == null || _selectedEndDate == null
                          ? 'Seleccionar fechas'
                          : 'Desde: ${_startDateController.text}\nHasta: ${_endDateController.text}',
                      style: const TextStyle(fontFamily: 'San Francisco'),
                    ),
                  ),
                  if (_dateError != null)
                    Text(
                      _dateError!,
                      style: TextStyle(
                          color: Colors.red, fontFamily: 'San Francisco'),
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idBusinessController,
                    decoration: InputDecoration(labelText: 'ID Negocio:'),
                    style: const TextStyle(fontFamily: 'San Francisco'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setStateDialog(() {
                        _validateForm();
                      });
                      if (_allFieldsValid()) {
                        _addDiscountToDatabase();
                      }
                    },
                    child: Text(
                      "Añadir",
                      style: TextStyle(fontFamily: 'San Francisco'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// Método para validar todos los campos
  void _validateForm() {
    _nameError =
        _nameController.text.isEmpty ? "El nombre no puede estar vacío" : null;
    _descriptionError = _descriptionController.text.isEmpty
        ? "La descripción no puede estar vacía"
        : null;
    _percentageError = int.tryParse(_percentageController.text) == null
        ? "Debe ser un número entero"
        : null;
    _dateError = (_selectedStartDate == null || _selectedEndDate == null)
        ? "Debe seleccionar las fechas"
        : null;
  }

  /// Método para verificar que todos los campos son válidos
  bool _allFieldsValid() {
    return _nameError == null &&
        _descriptionError == null &&
        _percentageError == null &&
        _dateError == null;
  }

  //Metodo para anadir el descuento a Supabase mediante el viewmodel

  Future<void> _addDiscountToDatabase() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      Discount discount = Discount(
        name: _nameController.text,
        description: _descriptionController.text,
        porcentaje: int.parse(_percentageController.text),
        startdate: _selectedStartDate!,
        enddate: _selectedEndDate!,
        state: _selectedStartDate!.isBefore(DateTime.now()),
        id_negocio: int.parse(_idBusinessController.text),
      );

      bool success = await discountViewModel.addDiscount(discount);

      if (success) {
        _showSuccessPopup();
      } else {
        throw Exception('Error al añadir el descuento');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir descuento: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _clearForm();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _percentageController.clear();
      _idBusinessController.clear();
      _selectedStartDate = null;
      _selectedEndDate = null;
    });
  }
}
*/
