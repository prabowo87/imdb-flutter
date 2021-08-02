

import 'package:flutter/material.dart';
import 'package:imdb/page/home_page.dart';
import 'package:imdb/providers/menu_provider.dart';
import 'package:imdb/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class ZoomPage extends StatefulWidget {
  final Widget? menuScreen;
  final Layout? contentScreen;

  ZoomPage({
    this.menuScreen,
    this.contentScreen,
  });
  static const routeName = "/zoom_page";
  @override
  ZoomPageState createState() => new ZoomPageState();

}

class ZoomPageState extends State<ZoomPage> with TickerProviderStateMixin{
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  createContentDisplay() {
    return zoomAndSlideContent(new Container(
      child: SafeArea(
        child: new Scaffold(
          // backgroundColor: Colors.red,
          appBar: new AppBar(
            title: Consumer<MovieProvider>(
                builder: (ctx, products, child) => products.appBarTitle),
            actions: <Widget>[
              IconButton(
                icon: Consumer<MovieProvider>(
                    builder: (ctx, products, child) =>products.actionIcon),
                onPressed: () {
                  Provider.of<MovieProvider>(context,listen: false).searcklik("OMDB",context);

                },
              ),
            ],
            backgroundColor: Colors.blue,
            // elevation: 1.0,
            leading: new IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Provider.of<MenuProvider>(context, listen: false).toggle();
                }),
          ),
          body: HomePage(),

        )
      ),
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (Provider.of<MenuProvider>(context, listen: true).state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(
            Provider.of<MenuProvider>(context, listen: true).percentOpen);
        scalePercent = scaleDownCurve.transform(
            Provider.of<MenuProvider>(context, listen: true).percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(
            Provider.of<MenuProvider>(context, listen: true).percentOpen);
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuProvider>(context, listen: true).percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius =
        16.0 * Provider.of<MenuProvider>(context, listen: true).percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
  
}

class ZoomScaffoldMenuProviderState extends StatelessWidget{
  final ZoomScaffoldBuilder? builder;

  const ZoomScaffoldMenuProviderState({this.builder});

  @override
  Widget build(BuildContext context) {
    return builder!(
        context, Provider.of<MenuProvider>(context, listen: true));
  }

}
typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuProvider menuController);
class Layout {
  final WidgetBuilder? contentBuilder;

  Layout({
    this.contentBuilder,
  });
}