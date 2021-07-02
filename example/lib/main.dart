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
        // bottomSheet: SlideUpBar(),
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
            list: _cardList, // required
            model: _cardModel, // required
            cardWithSingleColor: Color(0xffdee5cf), // either use this one
            cardWithGradientColors: [
              Color(0xfffff060), // or this one
              Color(0xFFD5D2D2),
              Color(0xFFfbc7d4)
            ],
            isRotatingCards: true, // set it false if you don't want 3D rotation
            cardHeight: 200, // change it according to your design
            cardWidth: 170, // change it according to your design
            moreText: 'Set any text here',
            onMoreBtnPressed: () {
              // write a code that takes you to the detail page of this card
            },
          ),
        )
        // bottomSheet: SlideUpBar(),
        );
  }
}
