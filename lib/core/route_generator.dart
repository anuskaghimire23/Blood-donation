
import 'package:blooddonation/bookRequest.dart';
import 'package:blooddonation/bottom_nav_bar.dart';
import 'package:blooddonation/center_page.dart';
import 'package:blooddonation/core/route.dart';
import 'package:blooddonation/find_donor_page.dart';
import 'package:blooddonation/loginPage.dart';
import 'package:blooddonation/my_request_page.dart';
import 'package:blooddonation/profile.dart';
import 'package:blooddonation/registerPage.dart';
import 'package:blooddonation/view_request_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static navigateToPage(BuildContext context, String route,
      {dynamic arguments}) {
    Navigator.push(context,
        generateRoute(RouteSettings(name: route, arguments: arguments)));
  }

  static navigateToPageWithoutStack(BuildContext context, String route,
      {dynamic arguments}) {
    Navigator.pushAndRemoveUntil(
        context,
        generateRoute(RouteSettings(name: route, arguments: arguments)),
        (route) => false);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) =>  loginPage());
         case Routes.bottomNavbarRoute:
        return MaterialPageRoute(builder: (_) =>const BottomNavbar() );
        case Routes.OnboardingRoute:
        return MaterialPageRoute(builder: (_) => registerPage());
             case Routes.FindDonorPage:
        return MaterialPageRoute(builder: (_) =>  FindDonorPage());
             case Routes.MyRequestPage:
        return MaterialPageRoute(builder: (_) =>RequestStatusPage());
             case Routes.BookRequestPage:
        return MaterialPageRoute(builder: (_) => BookRequestPage());
             case Routes.Center:
        return MaterialPageRoute(builder: (_) => CenterPage());
             case Routes.ViewRequestPage:
        return MaterialPageRoute(builder: (_) => ViewRequestPage());
        case Routes.ProfilePage:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}