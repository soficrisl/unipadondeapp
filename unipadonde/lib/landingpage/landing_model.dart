//Atributos del descuento
class Discount {
  final String name;
  final String category;
  final String description;
  final String buisnessLogo;
  final String duration;

  Discount({
    required this.name,
    required this.category,
    required this.buisnessLogo,
    required this.description,
    required this.duration,
  });
}

//Listamos los descuentos
final List<Discount> listOfDIscounts = [
  Discount(
    name: "Food Kart",
    category: "Games",
    description: "Ven a jugar GoKarts en 2x1",
    buisnessLogo: "assets/images/fk.png",
    duration: "2 dias",
  ),
  Discount(
    name: "Laser",
    category: "Travel",
    description: "20% descuento en pasajes Ccs-Miami",
    buisnessLogo: "assets/images/laser.png",
    duration: "1 dias",
  ),
  Discount(
    name: "Mykonos",
    category: "Food",
    description: "Por la compra de 3 helados uno gratis",
    buisnessLogo: "assets/images/mykonis.jpg",
    duration: "2 dias",
  ),
  Discount(
    name: "Plan B",
    category: "Food",
    description: "Cheeseburger clasica por tan solo 2 dolares",
    buisnessLogo: "assets/images/planb.png",
    duration: "2 dias",
  )
];
