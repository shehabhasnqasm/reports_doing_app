import 'package:flutter/material.dart';

// Navigation with animation
/*
page_transition: ^2.0.9
Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const CategoriesScreen(),
                  ),
                );

*/
//------------------------- navigation without animation ---------------
//1
class SlideTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  SlideTransitionAnimation({required this.page})
      : super(
            pageBuilder: (context, animation, animationtow) => page,
            transitionsBuilder: (context, animation, animationtow, child) {
              //___________ SlideTransition ____________

              const begin = Offset(1.0, 0.0);
              var end = Offset.zero; // Offset(1.0, 0.0)
              var tween = Tween(begin: begin, end: end);
              var offestAnimation = animation.drive(tween);
              return SlideTransition(
                position: offestAnimation,
                child: child,
              );
            });
}

//-----------------------------------------------------
//2
class SlideTransitionAnimation2 extends PageRouteBuilder {
  final Widget page;

  SlideTransitionAnimation2({required this.page})
      : super(
            pageBuilder: (context, animation, animationtow) => page,
            transitionsBuilder: (context, animation, animationtow, child) {
              //___________ SlideTransition 2 ____________

              const begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var tween = Tween(begin: begin, end: end);
              var curveAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInBack);
              return SlideTransition(
                position: tween.animate(curveAnimation),
                child: child,
              );
            });
}

//-----------------------------------------------------
// 3
class ScaleTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  ScaleTransitionAnimation({required this.page})
      : super(
            pageBuilder: (context, animation, animationtow) => page,
            transitionsBuilder: (context, animation, animationtow, child) {
              //___________ ScaleTransition ____________

              const begin = 0.0;
              var end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var curveAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInBack);
              return ScaleTransition(
                scale: tween.animate(curveAnimation),
                child: child,
              );
            });
}

//-----------------------------------------------------
// 4
class RotationTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  RotationTransitionAnimation({required this.page})
      : super(
            pageBuilder: (context, animation, animationtow) => page,
            transitionsBuilder: (context, animation, animationtow, child) {
              //___________ RotationTransition ____________

              const begin = 0.0;
              var end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var curveAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.linear);
              return RotationTransition(
                turns: tween.animate(curveAnimation),
                child: child,
              );
            });
}

//-----------------------------------------------------
// 5
class SizeTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  SizeTransitionAnimation({required this.page})
      : super(
            pageBuilder: (context, animation, animationtow) => page,
            transitionsBuilder: (context, animation, animationtow, child) {
              //___________ SizeTransition ____________

              return Align(
                alignment: Alignment.center,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
              );
            });
}

//-----------------------------------------------------
// 6
class FadeTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  FadeTransitionAnimation({required this.page})
      : super(
            pageBuilder: (context, animation, animationtow) => page,
            transitionsBuilder: (context, animation, animationtow, child) {
              //___________ FadeTransition ____________

              return FadeTransition(
                opacity: animation,
                child: child,
              );
            });
}

//-----------------------------------------------------
// 7
class ScaleRotationAnimation extends PageRouteBuilder {
  final Widget page;

  ScaleRotationAnimation({required this.page})
      : super(
            pageBuilder: (context, animation, animationtow) => page,
            transitionsBuilder: (context, animation, animationtow, child) {
              //___________ ScaleTransition and RotationTransition ____________

              const begin = 0.0;
              var end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var curveAnimation = CurvedAnimation(
                  parent: animation, curve: Curves.linearToEaseOut);
              return ScaleTransition(
                scale: tween.animate(curveAnimation),
                child: RotationTransition(
                  turns: tween.animate(curveAnimation),
                  child: child,
                ),
              );
            });
}





//__________________________________________________________________
// class PageAnimation extends PageRouteBuilder {
//   final Page;

//   PageAnimation({this.Page})
//       : super(
//             pageBuilder: (context, animation, animationtow) => Page,
//             transitionsBuilder: (context, animation, animationtow, child) {
//               //___________ SlideTransition ____________

//               const begin = Offset(1.0, 0.0);
//               var end = Offset.zero; // Offset(1.0, 0.0)
//               var tween = Tween(begin: begin, end: end);
//               var offestAnimation = animation.drive(tween);
//               return SlideTransition(
//                 position: offestAnimation,
//                 child: child,
//               );

//               /* 2
//               const begin = Offset(1.0, 0.0);
//               var end = Offset.zero;
//               var tween = Tween(begin: begin, end: end);
//               var curveAnimation =
//                   CurvedAnimation(parent: animation, curve: Curves.easeInBack);
//               return SlideTransition(
//                 position: tween.animate(curveAnimation),
//                 child: child,
//               );
//               */

//               //_________________________

//               //___________ ScaleTransition ____________

//               /*
//               const begin = 0.0;
//               var end = 1.0;
//               var tween = Tween(begin: begin, end: end);
//               var curveAnimation =
//                   CurvedAnimation(parent: animation, curve: Curves.easeInBack);
//               return ScaleTransition(
//                 scale: tween.animate(curveAnimation),
//                 child: child,
//               );
//               */
//               //_________________________

//               //___________ RotationTransition ____________

//               /*
//               const begin = 0.0;
//               var end = 1.0;
//               var tween = Tween(begin: begin, end: end);
//               var curveAnimation =
//                   CurvedAnimation(parent: animation, curve: Curves.linear);
//               return RotationTransition(
//                 turns: tween.animate(curveAnimation),
//                 child: child,
//               );
//               */

//               //_________________________

//               //___________ SizeTransition ____________
//               /*
//               return Align(
//                 alignment: Alignment.center,
//                 child: SizeTransition(
//                   sizeFactor: animation,
//                   child: child,
//                 ),
//               );
//               */

//               //_________________________

//               //___________ FadeTransition ____________
//               /*
//               return FadeTransition(
//                 opacity: animation,
//                 child: child,
//               );
//              */
//               //_________________________

//               //___________ ScaleTransition and RotationTransition ____________

//               // const begin = 0.0;
//               // var end = 1.0;
//               // var tween = Tween(begin: begin, end: end);
//               // var curveAnimation = CurvedAnimation(
//               //     parent: animation, curve: Curves.linearToEaseOut);
//               // return ScaleTransition(
//               //   scale: tween.animate(curveAnimation),
//               //   child: RotationTransition(
//               //     turns: tween.animate(curveAnimation),
//               //     child: child,
//               //   ),
//               // );
//             });
// }

// /*

//   1- set up a PageRouteBuilder .
//   2- create a Tween .
//   3- add an AnimatedWidget
//   4- use a CurveTween
//   5- combine the tow Tweens

// */

//  /*
// in ScaleTransition:

//   from right to left =>
//       const begin = Offset(1.0, 0.0);
//       var end = Offset(0.0, 0.0) ; // offset.zero ;

//   from left to right =>
//       const begin = Offset(-1.0, 0.0);
//       var end = Offset(0.0, 0.0) ;

//   from top to bottom =>
//       const begin = Offset(0.0, -1.0);
//       var end = Offset(0.0, 0.0) ;

//   from bottom to top =>
//       const begin = Offset(0.0, 1.0);
//       var end = Offset(0.0, 0.0) ;

//  */
