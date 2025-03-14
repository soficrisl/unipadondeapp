import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/business_view_prov/buspageprov_view.dart';
import 'package:unipadonde/business_view_prov/buspageprov_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_model.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_vm.dart';

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

  _BusinessInfoViewState()
      : currentBusiness = Business(
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
          .eq('id_negocio', currentBusiness.id)
          .eq('state', true);

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

    // Muestra el popup de éxito y espera a que el usuario lo cierre
    await _showSuccessPopup('Negocio eliminado correctamente.');

    // Llama a la función de actualización
    widget.onBusinessDeleted();

    // Navega de regreso a la pantalla anterior (Favsbusinesspage)
    Navigator.of(context).pop(); // Vuelve a la vista anterior
  } catch (e) {
    print('Negocio no eliminado');
  }
}

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
                currentBusiness.description,
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
                currentBusiness.tiktok,
                'assets/icons/tiktok.png',
              ),
              SizedBox(height: 10),
              _buildDetailContainer(
                'Instagram',
                currentBusiness.instagram,
                'assets/icons/instagram.png',
              ),
              SizedBox(height: 10),
              _buildDetailContainer(
                'Página web',
                currentBusiness.webpage,
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
              ] else if (isLoading)
                Center(child: CircularProgressIndicator())
              else
                _buildDetailContainer(
                    'Dirección', 'No se encontró la dirección', ''),
              SizedBox(height: 20),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (discounts.isEmpty)
                Center(child: Text('No hay descuentos disponibles'))
              else
                CarouselSlider(
                  options: CarouselOptions(
                    height:
                        250, // Altura reducida para mostrar solo nombre, descripción y botones
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
                        return GestureDetector(
                          onTap: () {
                            // Mostrar diálogo con la información completa del descuento
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  discount['name'],
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontFamily: "San Francisco",
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        discount['description'],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Descuento: ${discount['porcentaje']}%",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Válido desde: ${discount['startdate']} hasta ${discount['enddate']}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Cerrar'),
                                  ),
                                ],
                              ),
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
                                                discount);
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
                                                  '¿Estás seguro de que deseas eliminar el descuento "${discount['name']}"?',
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
                                                  discount['id']);
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
                        builder: (context) => BusinessPageProv(business: currentBusiness),
                      ),
                    );

                    // Si el resultado es true, actualiza los datos del negocio
                    if (result == true) {
                      await _refreshBusinessData(); // Actualiza los datos del negocio
                      await fetchDiscounts(); // Actualiza los descuentos
                      await fetchAddress(); // Actualiza la dirección
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
                          '¿Estás seguro de que deseas eliminar el negocio: "${currentBusiness.name}"?',
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
      Discount updatedDiscount = Discount(
        id: discountId,
        name: _nameController.text,
        description: _descriptionController.text,
        porcentaje: int.parse(_percentageController.text),
        startdate: _selectedStartDate!,
        enddate: _selectedEndDate!,
        state: _selectedStartDate!.isBefore(DateTime.now()),
        id_negocio: currentBusiness.id,
      );

      int? idBDD =
          await discountViewModel.updateDiscount(discountId, updatedDiscount);

      if (idBDD != null && idBDD != 0) {
        setState(() {
          int index = discounts.indexWhere((d) => d['id'] == discountId);
          if (index != -1) {
            discounts[index] = {
              'id': idBDD,
              'name': _nameController.text,
              'description': _descriptionController.text,
              'porcentaje': int.parse(_percentageController.text),
              'startdate': _selectedStartDate!.toIso8601String(),
              'enddate': _selectedEndDate!.toIso8601String(),
              'state': _selectedStartDate!.isBefore(DateTime.now()),
              'id_negocio': currentBusiness.id,
            };
          }
        });
        _showEditSuccessPopup();
      } else {
        throw Exception('Error al actualizar el descuento');
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

  Future<void> _deleteDiscountFromDatabase(int discountId) async {
    try {
      bool success = await discountViewModel.deleteDiscount(discountId);

      if (success) {
        setState(() {
          // Elimina el descuento de la lista local
          discounts.removeWhere((d) => d['id'] == discountId);
          print("Descuento eliminado localmente: $discountId");
        });
        _showDeleteSuccessPopup();
      } else {
        throw Exception('Error al eliminar el descuento');
      }
    } catch (e) {
      print('Error');
    }
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
      Discount discount = Discount(
        name: _nameController.text,
        description: _descriptionController.text,
        porcentaje: int.parse(_percentageController.text),
        startdate: _selectedStartDate!,
        enddate: _selectedEndDate!,
        state: _selectedStartDate!.isBefore(DateTime.now()),
        id_negocio: currentBusiness.id,
      );

      int? idBDD = await discountViewModel.addDiscount(discount);

      if (idBDD != null && idBDD != 0) {
        setState(() {
          // Agrega el nuevo descuento a la lista local
          discounts.add({
            'id': idBDD,
            'name': discount.name,
            'description': discount.description,
            'porcentaje': discount.porcentaje,
            'startdate': discount.startdate.toIso8601String(),
            'enddate': discount.enddate.toIso8601String(),
            'state': discount.state,
            'id_negocio': discount.id_negocio,
          });
        });
        _showAddSuccessPopup();
      } else {
        throw Exception('Error al añadir el descuento');
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
