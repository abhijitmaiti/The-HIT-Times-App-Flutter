import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/contact_us.dart';
import 'package:the_hit_times_app/news.dart';
import 'package:the_hit_times_app/notification_service/notification_service.dart';
import 'package:the_hit_times_app/smenu.dart';
// import 'notification.dart';
import 'bottom_nav_gallery.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int _currentIndex = 1;

  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  late List<Widget> _navigationViews;
  late PageController _pageController;


  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService().show(message);
    });

    _navigationViews = <Widget>[
      Icon(
        Icons.menu,
        color: Color(0xFF000000),
        size: 30,
      ),
      Icon(
        Icons.assignment,
        color: Color(0xFF000000),
        size: 30,
      ),
      Icon(
        Icons.info_outline,
        color: Color(0xFF000000),
        size: 30,
      ),
    ];

    for (Widget view in _navigationViews)

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    for (Widget view in _navigationViews)
    _pageController.dispose();
    super.dispose();
  }

  void campusNews(){
    setState(() {
      this._currentIndex = 1;
    });
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  void onPageChanged(int page) {
    setState(() {
      this._currentIndex = page;
    });
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if(details.primaryVelocity == 0) return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity!.compareTo(0) == -1) {
      print('dragged from left');
      print(_currentIndex);
      setState((){
        if(_currentIndex<2) {
          _currentIndex++;
        }
      });
    }
    else {
      print('dragged from right');
      print(_currentIndex);
      setState((){
        if(_currentIndex>0)
          _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CurvedNavigationBar botNavBar = CurvedNavigationBar(
      index: 1,
      height: 60.0,
      items: _navigationViews
          .toList(),
      backgroundColor: Colors.teal,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('The HIT Times'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),

      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) => _onHorizontalDrag(details),
        child: Stack(
          children: <Widget>[
            Offstage(
              offstage: _currentIndex != 0,
              child: TickerMode(
                enabled: _currentIndex == 0,
                child: Container(child : SMenu()),
              ),
            ),
            Offstage(
              offstage: _currentIndex != 1,
              child: TickerMode(
                enabled: _currentIndex == 1,
                child: Container(
                    child: News()
                ),
              ),
            ),
            Offstage(
              offstage: _currentIndex != 2,
              child: TickerMode(
                enabled: _currentIndex == 2,
                child: Container(
                  /*decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [const Color(0xFFddd6f3), const Color(0xFFffffff), const Color(0xFF9bc5c3)], // whitish to gray
                        stops: [0.0,0.3,1.0],
                        tileMode: TileMode.mirror, // repeats the gradient over the canvas
                      ),
                    ),*/
                    height: MediaQuery.of(context).size.height,
                    child: ContactUs()
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: botNavBar,
    );
  }
}