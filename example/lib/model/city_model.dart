import 'package:flutter/material.dart';

class CardModel {
  final String title;

  /// required
  final String imagePath;

  /// required
  final String description;

  /// (Optional)
  final Color color;

  /// (Optional) add this parameter if you want to have different color on each card
  final List<Color> colorList;

  /// (Optional) add this parameter if you want to apply different gradient on each card

  CardModel(
      {this.title,
      this.description: "",
      this.color,
      this.colorList: const <Color>[],
      this.imagePath});
}

class CardData {
  List<CardModel> _cardData = [
    CardModel(
        title: 'Colors, Vibrant',
        description:
            'Gardening is how I relax. It\'s another form of creating and playing with colors.',
        // color: Color(0xfff9d9e2), // 0xffdee5cf
        colorList: [Color(0xffacb6e5), Color(0xFFD5D2D2), Color(0xFFfbc7d4)],
        imagePath: "assets/images/colors.png"),
    CardModel(
        title: 'Budapest, Hungary',
        description:
            'Meet the CardModel with rich history and indescribable culture',
        colorList: [Color(0xFF4CAF50), Color(0xFF00BCD4), Color(0xFF99ca3d)],
        imagePath: "assets/images/city_image.png"),
    CardModel(
        title: 'London, England',
        description:
            'A diverse and exciting CardModel with the world’s best sights and attractions!',
        // color: Color(0xffdee5cf),
        colorList: [Color(0xfffff060), Color(0xFFD5D2D2), Color(0xFFfbc7d4)],
        imagePath: "assets/images/london_city.png"),
  ];

  List<CardModel> getCardList() => _cardData;
}
