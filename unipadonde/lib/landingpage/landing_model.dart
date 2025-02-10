class Discount {
  String name;
  String imagePath;

  Discount({
    required this.name,
    required this.imagePath,
  });
}

List<Discount> listOfDIscounts() {
  return [
    Discount(name: "Food Kart", imagePath: "bag1.png"),
    Discount(name: "Laser", imagePath: "bag2.png"),
    Discount(name: "Mykonos", imagePath: "bag3.png"),
  ];
}
