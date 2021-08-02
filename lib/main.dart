import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imdb/page/splash_page.dart';
import 'package:imdb/providers/favorite_provider.dart';
import 'package:imdb/providers/login_provider.dart';
import 'package:imdb/providers/movie_provider.dart';
import 'package:imdb/utils/shared_preferences_utils.dart';
import 'package:imdb/widgets/zoom_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart' as contstants;
import 'localdb/db_helper.dart';
import 'providers/menu_provider.dart';
import 'utils/route_utils.dart';
import 'widgets/menu_page_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = getLogin().then((userStatus) {
    if (userStatus == null || userStatus == false) {
      return false;
    } else {
      return true;
    }
  });

  runApp(
      EasyLocalization(
          supportedLocales: [
            Locale('id', 'ID'),
            Locale('en', 'US'),
          ],
          path: 'assets/langs',
          child: await isLoggedIn != null && await isLoggedIn==true?App(status: true,):App(status: false,)
      )

  );
}
class App extends StatelessWidget {
  App({Key? key, this.status}) : super(key: key);
  final bool? status;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //BERFUNGSI UNTUK ME-LOAD PROVIDER Products
        //JIKA MENGGUNAKAN LEBIH DARI 1 PROVIDER CUKUP PISAHKAN DENGAN COMMAND DI DALAM ARRAY providers.
        ChangeNotifierProvider( create: (_) => LoginProvider(),),
        ChangeNotifierProvider( create: (_) => MovieProvider(),),
        ChangeNotifierProvider( create: (_) => FavoriteProvider(),),
        // ChangeNotifierProvider( create: (_) => MenuProvider(),),

      ],
      child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          routes: appRoutes,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashPage(status: status,)
      )
    );

  }
}
class MyApp extends StatefulWidget {
  final bool? status;
  MyApp({Key? key,  this.status}) : super(key: key);
  @override
  _MyApp createState() => _MyApp();
  static const routeName = "/MyApp";

}
class _MyApp extends State<MyApp> with SingleTickerProviderStateMixin{
  late MenuProvider menuProvider;

  @override
  void initState() {

    super.initState();

    var dbHelper =new DbHelper();
    dbHelper.database;
    menuProvider = new MenuProvider(
      vsync: this,
    )..addListener(() => setState(() {}));

  }
  @override
  void dispose() {
    menuProvider.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      value:menuProvider,
      child  :ZoomPage(
        menuScreen: MenuPageWidget(),
        contentScreen: Layout(
            contentBuilder: (cc) => Container(
              color: Colors.grey[200],
              child: Container(
                color: Colors.grey[200],
              ),
            )),
      ),

    );
  }

}



