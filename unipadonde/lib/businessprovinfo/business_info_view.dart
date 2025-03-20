import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:unipadonde/business_view_prov/buspageprov_view.dart';
import 'package:unipadonde/businessprovinfo/business_info_vm.dart';
import 'package:unipadonde/validations.dart';
import 'package:unipadonde/modeldata/business_model.dart';
//import 'package:unipadonde/noti_service.dart';

class BusinessInfoView extends StatefulWidget {
  final Business business;
  final VoidCallback onBusinessDeleted; // Función de actualización  REVISAR

  const BusinessInfoView({
    super.key,
    required this.business,
    required this.onBusinessDeleted, // Acepta la función de actualización
  });

  @override
  State<BusinessInfoView> createState() => _BusinessInfoViewState();
}

class _BusinessInfoViewState extends State<BusinessInfoView> {
  Map<String, dynamic>? address;

  //late  DiscountViewModel discountViewModel;
  late BusinessInfoViewModel _viewModel;

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

  @override
  void initState() {
    super.initState();
    _viewModel = BusinessInfoViewModel(
        idNegocio: widget.business.id, business: widget.business);
    _viewModel.fetchDiscounts();
    _viewModel.fetchAddress();
    _viewModel.addListener(_onViewModelChange);
    _viewModel.setLoading(false);
  }

  void _onViewModelChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  // Método para actualizar los datos del negocio
  Future<void> _refreshBusinessData() async {
    try {
      await _viewModel.getUpdatedBusiness();
    } catch (e) {
      throw Exception('Error setting new state with business data: $e');
    }
  }

  // Método para eliminar el negocio
  Future<void> _deleteBusiness() async {
    try {
      await _viewModel.deleteBusiness();
      await _showSuccessPopup('Negocio eliminado correctamente.');
      // Llama a la función de actualización
      widget.onBusinessDeleted();
      // Navega de regreso a la pantalla anterior (Favsbusinesspage)
      if (mounted) {
        Navigator.of(context).pop();
      }
      // Vuelve a la vista anterior
    } catch (e) {
      print('Negocio no eliminado');
    }
  }

  Future<void> showDateTimeRangePicker() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime.now(),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime.now(),
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

  Future<void> _deleteDiscountFromDatabase(int discountId) async {
    try {
      bool success = await _viewModel.deleteDiscount(discountId);
      if (success) {
        _showDeleteSuccessPopup();
      } else {
        if (mounted) {
          showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'Error al eliminar descuento.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
        }
      }
    } catch (e) {
      print('Error');
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
                      color: Colors.white,
                      border: Border.all(
                          color: const Color(0xFFFFA500), width: 4.0),
                    ),
                    child: _viewModel.business.imageurl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              _viewModel.business.imageurl,
                              fit: BoxFit
                                  .contain, // Matches the behavior of Image.asset
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                              widget.business.picture,
                              fit: BoxFit.contain, // Keeps the style consistent
                            ),
                          ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _viewModel.business.name,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'San Francisco',
                        color: Colors.black,
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
                _viewModel.business.description,
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
                _viewModel.business.tiktok,
                'assets/icons/tiktok.png',
              ),
              SizedBox(height: 10),
              _buildDetailContainer(
                'Instagram',
                _viewModel.business.instagram,
                'assets/icons/instagram.png',
              ),
              SizedBox(height: 10),
              _buildDetailContainer(
                'Página web',
                _viewModel.business.webpage,
                'assets/icons/sitio-web.png',
              ),
              SizedBox(height: 10),
              if (address != null) ...[
                _buildDetailContainer('Estado', address!['estado'], ''),
                SizedBox(height: 10),
                _buildDetailContainer('Ciudad', address!['ciudad'], ''),
                SizedBox(height: 10),
                _buildDetailContainer('Municipio', address!['municipio'], ''),
                SizedBox(height: 10),
                _buildDetailContainer('Calle', address!['calle'], ''),
                if (address!['additional_info'] != null) ...[
                  SizedBox(height: 10),
                  _buildDetailContainer(
                    'Información adicional',
                    address!['additional_info'],
                    '',
                  ),
                ],
              ] else if (_viewModel.isLoading())
                Center(child: CircularProgressIndicator())
              else
                _buildDetailContainer(
                    'Dirección', 'No se encontró la dirección', ''),
              SizedBox(height: 20),
              if (_viewModel.isLoading())
                Center(child: CircularProgressIndicator())
              else if (_viewModel.discounts.isEmpty)
                Center(child: Text('No hay descuentos disponibles'))
              else
                CarouselSlider(
                  options: CarouselOptions(
                    height:
                        250, // Altura reducida para mostrar solo nombre, descripción y botones
                    autoPlay: _viewModel.discounts.length > 1,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: _viewModel.discounts.length > 1,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction:
                        _viewModel.discounts.length > 1 ? 0.9 : 1.0,
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
                                        discount.name,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              discount.description,
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
                                                    "${discount.porcentaje}%",
                                                    style: TextStyle(
                                                      color: Colors.orange,
                                                      fontFamily:
                                                          "San Francisco",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 64,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "Válido desde: ",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          "San Francisco",
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    " ${Validations.formatDate(discount.startdate)}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "San Francisco",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 97, 97, 97),
                                                    ),
                                                  ),
                                                  Text(
                                                    "hasta: ",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          "San Francisco",
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    " ${Validations.formatDate(discount.enddate)}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "San Francisco",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 95, 95, 95),
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
                                          padding: const EdgeInsets.only(
                                              top:
                                                  1), // Reduces the top padding
                                          child: TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              'Cerrar',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: "San Francisco",
                                                color: Color.fromARGB(
                                                    255, 102, 150, 232),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
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
                                  // Botones de editar y eliminar
                                  Positioned(
                                    top: 3,
                                    right: 8,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: const Color(
                                                  0xFF8CB1F1)), // Icono azul
                                          onPressed: () async {
                                            await showEditDiscountDialog(
                                                discount.toJson());
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: const Color(
                                                  0xFF8CB1F1)), // Icono rojo
                                          onPressed: () async {
                                            final confirm = await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                title: Center(
                                                  child: Text(
                                                    'Eliminar descuento',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'San Francisco',
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                content: Text(
                                                  '¿Estás seguro de que deseas eliminar el descuento "${discount.name}"?',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'San Francisco',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text(
                                                      'Cancelar',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'San Francisco',
                                                        color:
                                                            Color(0xFF8CB1F1),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: Text(
                                                      'Eliminar',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'San Francisco',
                                                        color: Colors.redAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              await _deleteDiscountFromDatabase(
                                                  discount.id);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Contenido del descuento (nombre y descripción)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40), // Espacio para los botones
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Nombre del descuento
                                        Text(
                                          discount.name,
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
                                          discount.description,
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
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    showAddDiscountDialog();
                  },
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                FloatingActionButton(
                  heroTag: "editButton",
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BusinessPageProv(business: _viewModel.business),
                      ),
                    );
                    // Si el resultado es true, actualiza los datos del negocio
                    if (result == true) {
                      await _refreshBusinessData(); // Actualiza los datos del negocio
                    }
                  },
                  backgroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFF8CB1F1), width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.edit, color: Color(0xFF8CB1F1)),
                ),
                const SizedBox(width: 15),
                FloatingActionButton(
                  heroTag: "deleteButton",
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Center(
                          child: Text(
                            'Eliminar negocio',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'San Francisco',
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        content: Text(
                          '¿Estás seguro de que deseas eliminar el negocio: "${_viewModel.business.name}"?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 16,
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                fontFamily: 'San Francisco',
                                color: Color(0xFF8CB1F1),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Eliminar',
                              style: TextStyle(
                                fontFamily: 'San Francisco',
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await _deleteBusiness();
                    }
                  },
                  backgroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  //Metodo para editar informacion del descuento
  Future<void> showEditDiscountDialog(Map<String, dynamic> discount) async {
    _nameController.text = discount['name'];
    _descriptionController.text = discount['description'];
    _percentageController.text = discount['porcentaje'].toString();
    _startDateController.text = discount['startdate'];
    _endDateController.text = discount['enddate'];
    _selectedStartDate = DateTime.parse(discount['startdate']);
    _selectedEndDate = DateTime.parse(discount['enddate']);

    await showDialog(
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
                    onPressed: () {
                      _clearForm(); // Limpia el formulario al cerrar
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Text(
                  "Editar Descuento",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'San Francisco',
                      color: Color(0xFFFFA500)),
                ),
                const SizedBox(height: 25),
                _buildTextFieldContainer(
                  controller: _nameController,
                  labelText: 'Nombre:',
                  errorText: _nameError,
                  onChanged: (_) {
                    setStateDialog(() {
                      _nameError = _nameController.text.isEmpty
                          ? "El nombre no puede estar vacío"
                          : null;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTextFieldContainer(
                  controller: _descriptionController,
                  maxLines: 6,
                  labelText: 'Descripción:',
                  errorText: _descriptionError,
                  onChanged: (_) {
                    setStateDialog(() {
                      _descriptionError = _descriptionController.text.isEmpty
                          ? "La descripción no puede estar vacía"
                          : null;
                    });
                  },
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                ),
                const SizedBox(height: 20),
                _buildTextFieldContainer(
                  controller: _percentageController,
                  labelText: 'Porcentaje:',
                  errorText: _percentageError,
                  onChanged: (_) {
                    setStateDialog(() {
                      _percentageError =
                          int.tryParse(_percentageController.text) == null
                              ? "Debe ser un número entero"
                              : null;
                    });
                  },
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () async {
                    await showDateTimeRangePicker(); // Selección de fechas
                    setStateDialog(() {
                      _dateError = (_selectedStartDate == null ||
                              _selectedEndDate == null)
                          ? "Debe seleccionar las fechas"
                          : null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white, // Fondo blanco
                    side: BorderSide(
                        color: Color(0xFFFFA500), width: 2), // Borde naranja
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Bordes redondeados
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12, // Más espacio vertical
                      horizontal: 16, // Espacio horizontal para el texto
                    ),
                  ),
                  child: Text(
                    _selectedStartDate == null || _selectedEndDate == null
                        ? 'Seleccionar fechas'
                        : 'Desde: ${_startDateController.text}\nHasta: ${_endDateController.text}',
                    textAlign: TextAlign.center, // Alineación central del texto
                    style: TextStyle(
                      color: Color(0xFFFFA500), // Texto en naranja
                      fontFamily: 'San Francisco',
                      fontSize: 16, // Tamaño de fuente adecuado
                    ),
                  ),
                ),
                if (_dateError != null)
                  Text(
                    _dateError!,
                    style: TextStyle(
                        color: Colors.red, fontFamily: 'San Francisco'),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    setStateDialog(() {
                      _validateForm();
                    });
                    if (_allFieldsValid()) {
                      await _updateDiscountInDatabase(
                          discount['id']); // Guardar
                    }
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
                    "Guardar Cambios",
                    style: TextStyle(fontFamily: 'San Francisco'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Metodo para update el descuento en supabase con el ViewModel
  Future<void> _updateDiscountInDatabase(int discountId) async {
    try {
      String startDate = _selectedStartDate!.toIso8601String();
      String endDate = _selectedEndDate!.toIso8601String();

      Map<String, dynamic> discountMap = {
        "id": discountId,
        "name": _nameController.text,
        "description": _descriptionController.text,
        "porcentaje": int.parse(_percentageController.text),
        "startdate": startDate, // Make sure you assign a value to this.
        "enddate": endDate,
        "state": _selectedStartDate!.isBefore(DateTime.now()),
        "id_negocio": _viewModel.business.id,
      };
      final response = await _viewModel.updateDiscount(discountId, discountMap);
      if (response) {
        _showEditSuccessPopup();
      }
    } catch (e) {
      print('Error');
    }
  }

  void _showEditSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              "¡Éxito!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'San Francisco',
                fontSize: 25,
                color: Color(0xFF8CB1F1),
              ),
            ),
          ),
          content: Text(
            "El descuento se ha actualizado correctamente.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: 16,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'San Francisco',
                  color: Color(0xFF8CB1F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _showDeleteSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              "¡Éxito!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'San Francisco',
                fontSize: 25,
                color: Color(0xFF8CB1F1),
              ),
            ),
          ),
          content: Text(
            "El descuento se ha eliminado correctamente.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: 16,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'San Francisco',
                  color: Color(0xFF8CB1F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          ],
        );
      },
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
                      onPressed: () {
                        _clearForm();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Text("Añadir Descuento",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'San Francisco',
                        color: Colors.black,
                      )),
                  const SizedBox(height: 25),
                  _buildTextFieldContainer(
                    controller: _nameController,
                    labelText: 'Nombre:',
                    errorText: _nameError,
                    onChanged: (_) {
                      setStateDialog(() {
                        _nameError = _nameController.text.isEmpty
                            ? "El nombre no puede estar vacío"
                            : null;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextFieldContainer(
                      controller: _descriptionController,
                      maxLines: 6,
                      labelText: 'Descripción:',
                      errorText: _descriptionError,
                      onChanged: (_) {
                        setStateDialog(() {
                          _descriptionError =
                              _descriptionController.text.isEmpty
                                  ? "La descripción no puede estar vacía"
                                  : null;
                        });
                      },
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
                  const SizedBox(height: 20),
                  _buildTextFieldContainer(
                    controller: _percentageController,
                    labelText: 'Porcentaje:',
                    errorText: _percentageError,
                    onChanged: (_) {
                      setStateDialog(() {
                        _percentageError =
                            int.tryParse(_percentageController.text) == null
                                ? "Debe ser un número entero"
                                : null;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () async {
                      await showDateTimeRangePicker();
                      setStateDialog(() {
                        _dateError = (_selectedStartDate == null ||
                                _selectedEndDate == null)
                            ? "Debe seleccionar las fechas"
                            : null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFFFFA500), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    child: Text(
                      _selectedStartDate == null || _selectedEndDate == null
                          ? 'Seleccionar fechas'
                          : 'Desde: ${_startDateController.text}\nHasta: ${_endDateController.text}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFA500),
                        fontFamily: 'San Francisco',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (_dateError != null)
                    Text(
                      _dateError!,
                      style: TextStyle(
                          color: Colors.red, fontFamily: 'San Francisco'),
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                    //! NOTIFICACIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOON ESTÁ FALLANDO ESTA VAINA AYUDA

                    /*
                      NotiService().showNotification(
                      title: 'Titulo',
                      body: 'Body',
                    ); 
                    */

                      setStateDialog(() {
                        _validateForm();
                      });
                      if (_allFieldsValid()) {
                        _addDiscountToDatabase();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFA500),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
    try {
      String startDate = _selectedStartDate!.toIso8601String();
      ;
      String endDate = _selectedEndDate!.toIso8601String();

      Map<String, dynamic> discountMap = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        "porcentaje": int.parse(_percentageController.text),
        "startdate": startDate, // Make sure you assign a value to this.
        "enddate": endDate,
        "state": _selectedStartDate!.isBefore(DateTime.now()),
        "id_negocio": _viewModel.business.id,
      };

      _nameController.clear();
      _descriptionController.clear();
      _percentageController.clear();
      final response = await _viewModel.addDiscount(discountMap);

      if (response) {
        _showAddSuccessPopup();
        _viewModel.fetchDiscounts();
      }
    } catch (e) {
      print('Error');
    }
  }

  void _showAddSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              "¡Éxito!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'San Francisco',
                fontSize: 25,
                color: Color(0xFF8CB1F1),
              ),
            ),
          ),
          content: Text(
            "El descuento se ha creado  correctamente.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: 16,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'San Francisco',
                  color: Color(0xFF8CB1F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
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

  // ! POP UP DE ÉXITO
  Future<void> _showSuccessPopup(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              "¡Éxito!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'San Francisco',
                fontSize: 25,
                color: Color(0xFF8CB1F1),
              ),
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: 16,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el popup
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'San Francisco',
                  color: Color(0xFF8CB1F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget para la estetica de los textfields
  Widget _buildTextFieldContainer({
    required TextEditingController controller,
    required String labelText,
    String? errorText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 10),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
          floatingLabelStyle: TextStyle(fontSize: 20, color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8CB1F1), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFA500), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
