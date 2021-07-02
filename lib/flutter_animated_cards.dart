library flutter_animated_cards;

import 'package:flutter/material.dart';
import 'src/rotation_3d.dart';
import 'src/styles.dart';

class FlutterAnimatedCards extends StatefulWidget {
  /// width and height of card
  double cardWidth, cardHeight;

  /// a bool var- if it's set to 'true' cards will show its 3D rotation pattern else it will behave as 2D
  bool isRotatingCards = true;

  /// background [Color] of card
  final Color cardWithSingleColor;

  /// list of [Color] used for apply gradient of card
  final List<Color> cardWithGradientColors;

  /// we need model to display information (text and images) on cards
  var model;
  var currentCardData;

  /// list to show number of cards and render data
  final List<dynamic> list;

  /// card click event. You can perform your desire action by using this click event when user is clicking on card
  Function onMoreBtnPressed;

  /// by default this text is set to 'LEARN MORE' you can change it to your choice
  String moreText;

  FlutterAnimatedCards({
    Key key,
    this.cardWidth: 160,
    this.cardHeight: 200,
    isRotatingCards: true,
    this.cardWithSingleColor: const Color(0xffdaf3f7),
    this.cardWithGradientColors: const <Color>[],
    @required this.list: const <dynamic>[],
    @required this.model,
    this.moreText: "Learn More",
    this.onMoreBtnPressed,
  }) : super(key: key);

  @override
  FlutterAnimatedCardsState createState() => FlutterAnimatedCardsState();
}

class FlutterAnimatedCardsState extends State<FlutterAnimatedCards>
    with SingleTickerProviderStateMixin {
  final double _maxRotation = 20;

  PageController _pageController;

  double _normalizedOffset = 0;
  double _prevScrollX = 0;
  bool _isScrolling = false;

  AnimationController _tweenController;
  Tween<double> _tween;
  Animation<double> _tweenAnim;

  @override
  void initState() {
    int tweenTime = 1000;
    _tweenController = AnimationController(
        vsync: this, duration: Duration(milliseconds: tweenTime));

    ///Create Tween, which defines our begin + end values
    _tween = Tween<double>(begin: -1, end: 0);

    widget.currentCardData = widget.list[1];

    super.initState();
  }

  void onCardChangeListener(var model) {
    setState(() {
      this.widget.currentCardData = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    widget.cardHeight = (size.height * .48).clamp(300.0, 400.0);
    widget.cardWidth = widget.cardHeight * .8;

    ///Calculate the viewPort fraction for this aspect ratio, since PageController does not accept pixel based size values
    _pageController = PageController(
        initialPage: 1, viewportFraction: widget.cardWidth / size.width);

    ///Create our main list
    Widget listContent = Container(
      ///Wrap list in a container to control height and padding
      height: widget.cardHeight,

      ///Use a ListView.builder, calls buildItemRenderer() lazily, whenever it need to display a listItem
      child: PageView.builder(
        ///Use bounce-style scroll physics, feels better with this demo
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        itemCount: widget.list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => _buildItemRenderer(widget.list[i]),
      ),
    );

    /// Wrap our list content in a Listener to detect PointerUp events, and a NotificationListener to detect ScrollStart and ScrollUpdate
    /// We have to use both, because NotificationListener does not inform us when the user has lifted their finger.
    /// We can not use GestureDetector like we normally would, ListView suppresses it while scrolling.
    return Listener(
      onPointerUp: _handlePointerUp,
      child: NotificationListener(
        onNotification: _handleScrollNotifications,
        child: listContent,
      ),
    );
  }

  ///Create a renderer for each list item
  Widget _buildItemRenderer(var dummyModel) {
    return Container(
      ///Vertically pad all the non-selected items, to make them smaller. AnimatedPadding widget handles the animation.
      child: Rotation3d(
        rotationY:
            widget.isRotatingCards ? _normalizedOffset * _maxRotation : 0,

        ///Create the actual content renderer for our list
        child: TravelCardRenderer(
          ///Pass in the offset, renderer can update it's own view from there
          _normalizedOffset,
          cardWidth: widget.cardWidth,
          model: dummyModel,
          cardHeight: widget.cardHeight,
          cardWithSingleColor: widget.cardWithSingleColor,
          cardWithGradientColors: widget.cardWithGradientColors,
          onMoreBtnPressed: widget.onMoreBtnPressed,
          moreText: widget.moreText,
        ),
      ),
    );
  }

  ///Check the notifications bubbling up from the ListView, use them to update our currentOffset and isScrolling state
  bool _handleScrollNotifications(Notification notification) {
    ///Scroll Update, add to our current offset, but clamp to -1 and 1
    if (notification is ScrollUpdateNotification) {
      if (_isScrolling) {
        double dx = notification.metrics.pixels - _prevScrollX;
        double scrollFactor = .01;
        double newOffset = (_normalizedOffset + dx * scrollFactor);
        _setOffset(newOffset.clamp(-1.0, 1.0));
      }
      _prevScrollX = notification.metrics.pixels;

      ///Calculate the index closest to middle
      ///_focusedIndex = (_prevScrollX / (_itemWidth + _listItemPadding)).round();
      onCardChangeListener(widget.list
          .elementAt(_pageController.page.round() % widget.list.length));
    }

    ///Scroll Start
    else if (notification is ScrollStartNotification) {
      _isScrolling = true;
      _prevScrollX = notification.metrics.pixels;
      if (_tween != null) {
        _tweenController.stop();
      }
    }
    return true;
  }

  ///If the user has released a pointer, and is currently scrolling, we'll assume they're done scrolling and tween our offset to zero.
  ///This is a bit of a hack, we can't be sure this event actually came from the same finger that was scrolling, but should work most of the time.
  void _handlePointerUp(PointerUpEvent event) {
    if (_isScrolling) {
      _isScrolling = false;
      _startOffsetTweenToZero();
    }
  }

  ///Helper function, any time we change the offset, we want to rebuild the widget tree, so all the renderers get the new value.
  void _setOffset(double value) {
    setState(() {
      _normalizedOffset = value;
    });
  }

  ///Tweens our offset from the current value, to 0
  void _startOffsetTweenToZero() {
    ///The first time this runs, setup our controller, tween and animation. All 3 are required to control an active animation.
    int tweenTime = 1000;
    if (_tweenController == null) {
      ///Create Controller, which starts/stops the tween, and rebuilds this widget while it's running
      _tweenController = AnimationController(
          vsync: this, duration: Duration(milliseconds: tweenTime));

      ///Create Tween, which defines our begin + end values
      _tween = Tween<double>(begin: -1, end: 0);

      ///Create Animation, which allows us to access the current tween value and the onUpdate() callback.
      _tweenAnim = _tween.animate(new CurvedAnimation(
          parent: _tweenController, curve: Curves.elasticOut))

        ///Set our offset each time the tween fires, triggering a rebuild
        ..addListener(() {
          _setOffset(_tweenAnim.value);
        });
    }

    ///Restart the tweenController and inject a new start value into the tween
    _tween.begin = _normalizedOffset;
    _tweenController.reset();
    _tween.end = 0;
    _tweenController.forward();
  }
}

class TravelCardRenderer extends StatelessWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  final Color cardWithSingleColor;
  final List<Color> cardWithGradientColors;
  var model;
  Function onMoreBtnPressed;
  String moreText;

  TravelCardRenderer(
    this.offset, {
    Key key,
    this.cardWidth = 250,
    this.cardHeight,
    this.cardWithSingleColor,
    this.cardWithGradientColors: const <Color>[],
    this.model,
    this.moreText,
    this.onMoreBtnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        '======================= cardWithGradientColors  ${cardWithGradientColors}');
    print('======================= model.colorList  ${model.colorList}');
    LinearGradient _linearGradient;
    if (model.colorList != null && model.colorList.length > 0) {
      _linearGradient = LinearGradient(
          colors: model.colorList,
          stops: (model.colorList.length == 0)
              ? []
              : (model.colorList.length == 1)
                  ? [1.0]
                  : (model.colorList.length == 2)
                      ? [0.5, 1.0]
                      : [0.0, 0.5, 1.0],
          tileMode: TileMode.mirror,
          end: Alignment.bottomCenter,
          begin: Alignment.topRight);
    } else if (cardWithGradientColors != null &&
        cardWithGradientColors.length > 0) {
      _linearGradient = LinearGradient(
          colors: cardWithGradientColors,
          stops: (cardWithGradientColors.length == 0)
              ? []
              : (cardWithGradientColors.length == 1)
                  ? [1.0]
                  : (cardWithGradientColors.length == 2)
                      ? [0.5, 1.0]
                      : [0.0, 0.5, 1.0],
          tileMode: TileMode.mirror,
          end: Alignment.bottomCenter,
          begin: Alignment.topRight);
    } else {
      _linearGradient = null;
    }
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(top: 8),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          // Card background color & decoration
          Container(
            margin: EdgeInsets.only(top: 30, left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              gradient: _linearGradient,
              color: model.color == null ? cardWithSingleColor : model.color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4 * offset.abs()),
                BoxShadow(
                    color: Colors.black12, blurRadius: 10 + 6 * offset.abs()),
              ],
            ),
          ),
          // City image, out of card by 15px
          Positioned(top: -15, child: _buildCityImage()),
          // City information
          _buildCityData()
        ],
      ),
    );
  }

  Widget _buildCityImage() {
    double maxParallax = 30;
    double globalOffset = offset * maxParallax * 2;
    double cardPadding = 28;
    double containerWidth = cardWidth - cardPadding;
    return Container(
      height: cardHeight,
      width: containerWidth,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // _buildPositionedLayer("assets/images/${city.name}/${city.name}-Back.png", containerWidth * .8, maxParallax * .1, globalOffset),
          // _buildPositionedLayer("assets/images/${city.name}/${city.name}-Middle.png", containerWidth * .9, maxParallax * .6, globalOffset),
          // _buildPositionedLayer("assets/images/${city.name}/${city.name}-Front.png", containerWidth * .9, maxParallax, globalOffset),
          _buildPositionedLayer(
              model.imagePath, containerWidth * .9, maxParallax, globalOffset),
        ],
      ),
    );
  }

  Widget _buildCityData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The sized box mock the space of the city image
        SizedBox(width: double.infinity, height: cardHeight * .57),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            model.title,
            style: Styles.cardTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              model.description,
              style: Styles.cardSubtitle,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
        ),
        // Expanded(child: SizedBox(),),
        FlatButton(
          disabledColor: Colors.transparent,
          color: Colors.transparent,
          child: Text(moreText.toUpperCase(), style: Styles.cardAction),
          onPressed: () {
            if (onMoreBtnPressed != null) {
              onMoreBtnPressed();
            }
          },
        ),
        SizedBox(height: 8)
      ],
    );
  }

  Widget _buildPositionedLayer(
      String path, double width, double maxOffset, double globalOffset) {
    double cardPadding = 24;
    double layerWidth = cardWidth - cardPadding;
    return Positioned(
        left: ((layerWidth * .5) - (width / 2) - offset * maxOffset) +
            globalOffset,
        bottom: cardHeight * .45,
        child: Image.asset(
          path,
          width: width,
          // package: App.pkg,
        ));
  }
}
