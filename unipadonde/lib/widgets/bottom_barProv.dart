import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomBottomBarProv extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomBarProv({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(69),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onItemTapped(0),
            icon: Icon(
              FeatherIcons.home,
              size: 30,
              color:
                  selectedIndex == 0 ? const Color(0xFFFFA500) : Colors.black,
            ),
          ),
          IconButton(
            onPressed: () => onItemTapped(2),
            icon: Icon(
              FeatherIcons.user,
              size: 30,
              color:
                  selectedIndex == 2 ? const Color(0xFFFFA500) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
