import 'package:flutter/material.dart';
import 'model/city_model.dart';

import 'package:flutter_animated_cards/flutter_animated_cards.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated 3D Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SimpleCardDemo(),
    );
  }
}

class SimpleCardDemo extends StatefulWidget {
  @override
  _SimpleCardDemoState createState() => _SimpleCardDemoState();
}

class _SimpleCardDemoState extends State<SimpleCardDemo> {
  List<CardModel> _cardList;
  CardModel _cardModel;

  @override
  void initState() {
    var data = CardData();
    _cardList = data.getCardList();
    _cardModel = _cardList[1];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Animated 3D Cards"),
        ),
        body: Center(
          child: FlutterAnimatedCards(
            list: _cardList,
            model: _cardModel,
          ),
        )
        );
  }
}

class FullyCustomizedCards extends StatefulWidget {
  @override
  _FullyCustomizedCardsState createState() => _FullyCustomizedCardsState();
}

class _FullyCustomizedCardsState extends State<FullyCustomizedCards> {
  List<CardModel> _cardList;
  CardModel _cardModel;

  @override
  void initState() {
    var data = CardData();
    _cardList = data.getCardList();
    _cardModel = _cardList[1];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Animated 3D Cards"),
        ),
        body: Center(
          child: FlutterAnimatedCards(
            /// required
            list: _cardList,

            /// required
            model: _cardModel,

            /// either use this one
            cardWithSingleColor: Color(0xffdee5cf),

            /// or this one
            cardWithGradientColors: [
              Color(0xfffff060),
              Color(0xFFD5D2D2),
              Color(0xFFfbc7d4)
            ],

            /// set it false if you don't want 3D rotation
            isRotatingCards: true,

            /// change it according to your design
            cardHeight: 200,

            /// change it according to your design
            cardWidth: 170,

            moreText: 'Set any text here',
            onMoreBtnPressed: () {
              /// write a code that takes you to the detail page of this card
            },
          ),
        )

        /// bottomSheet: SlideUpBar(),
        );
  }
}
