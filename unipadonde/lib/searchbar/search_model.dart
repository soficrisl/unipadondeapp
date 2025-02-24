class Buisness {
  final String id;
  final String name;
  final String buisnessLogo;

  Buisness({
    required this.id,
    required this.name,
    required this.buisnessLogo,
  });
}

final List<Buisness> allBuisness = [
  Buisness(
      id: '1', name: 'Coca-Cola', buisnessLogo: 'assets/images/cocacola.jpg'),
  Buisness(id: '2', name: 'Apple', buisnessLogo: 'assets/images/apple.png'),
  Buisness(id: '3', name: 'Zara', buisnessLogo: 'assets/images/zara.jpg'),
  Buisness(id: '4', name: 'Nike', buisnessLogo: 'assets/images/nike.jpg'),
  Buisness(
      id: '5',
      name: 'American Airlines',
      buisnessLogo: 'assets/images/american.jpg'),
];
