//Atributos del descuento
class Discount {
  final String name;
  final String category;
  final String description;
  final String buisness_logo;

  Discount({
    required this.name,
    required this.category,
    required this.buisness_logo,
    required this.description,
  });
}

//Listamos los descuentos
final List<Discount> listOfDIscounts = [
  Discount(
      name: "Food Kart",
      category: "Games",
      description: "Ven a jugar GoKarts en 2x1",
      buisness_logo: "assets/images/fk.png"),
  Discount(
      name: "Laser",
      category: "Travel",
      description: "20% descuento en pasajes Ccs-Miami",
      buisness_logo: "assets/images/laser.png"),
  Discount(
      name: "Mykonos",
      category: "Food",
      description: "Por la compra de 3 helados uno gratis",
      buisness_logo: "assets/images/mykonis.jpg"),
  Discount(
      name: "Plan B",
      category: "Food",
      description: "Cheeseburger clasica por tan solo 2 dolares",
      buisness_logo: "assets/images/planb.png")
];
