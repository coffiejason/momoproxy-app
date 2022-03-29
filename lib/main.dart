import 'package:flutter/material.dart';
import 'package:momoproxy/screens/login.dart';
import 'package:momoproxy/screens/home.dart';
import 'package:momoproxy/screens/getvendor.dart';
import 'package:momoproxy/screens/customer_profile.dart';
import 'package:momoproxy/screens/vendorpage.dart';
import 'package:momoproxy/screens/onboard.dart';
import 'package:momoproxy/screens/intro.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

void checkASV() {}

late String routeToGo = '/home';
late String transactionID = '';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String? payload;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("_firebaseMessagingBackgroundHandler Clicked! ${message.data["vid"]}");
  _handleMessage(message);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // titletion
  importance: Importance.high,
);

Future<void> selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
    print(payload);
    print(" message recieved now run checkASV");
    navigatorKey.currentState?.pushNamed('/home', arguments: payload);
    //navigatorKey.onGenerateRout
  }
}

void _handleMessage(RemoteMessage message) {
  // if (message.data["type"] == 'asv') {
  //   // navigatorKey.currentState
  //   //     ?.pushNamed('/loadscreen', arguments: "${message.data["vid"]}");

  // }
  navigatorKey.currentState?.pushNamed('/intro');
}

Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //initialize background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  setupInteractedMessage();

  // // assign channel (required after android 8)
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // // initialize notification for android
  // var initialzationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/launcher_icon');
  // var initializationSettings =
  //     InitializationSettings(android: initialzationSettingsAndroid);
  // flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // print('payload=');
  // payload = notificationAppLaunchDetails!.payload;
  // if (payload != null) {
  //   print(payload);

  //   print(" message recieved now run checkASV");
  //   routeToGo = '/home';
  //   navigatorKey.currentState?.pushNamed('/home', arguments: "2");
  // }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print(message.notification!.body != null);
    if (message.notification!.body != null) {
      payload = "${message.data["tid"]}";
      print(payload);

      print(" message recieved now run checkASV");
      navigatorKey.currentState
          ?.pushNamed('/loadscreen', arguments: "${message.data["tid"]}");
    }
  });

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: selectNotification);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/intro",
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        routes: <String, WidgetBuilder>{
          "/login": (BuildContext context) => new LoginPage(),
          "/home": (BuildContext context) => new HomeScreen(),
          "/onboard": (BuildContext context) => new OnboardScreen(),
          "/intro": (BuildContext context) => new IntroScreen(),
          "/getVendor": (BuildContext context) => new GetVendorScreen(),
          "/customerprofile": (BuildContext context) => new VendorProfile(),
          "/vendorpage": (BuildContext context) => new VendorPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginPage(),
              );
              break;
            case '/home':
              return MaterialPageRoute(
                builder: (_) => OnboardScreen(),
              );
              break;
            case '/intro':
              return MaterialPageRoute(
                builder: (_) => IntroScreen(),
              );
              break;
            case '/getVendor':
              return MaterialPageRoute(
                builder: (_) => GetVendorScreen(),
              );
              break;
            case '/customerprofile':
              return MaterialPageRoute(
                builder: (_) => VendorProfile(),
              );
              break;
            case '/vendorpage':
              return MaterialPageRoute(
                builder: (_) => VendorPage(),
              );
              break;
            case '/onboard':
              return MaterialPageRoute(
                builder: (_) => OnboardScreen(),
              );
              break;
            // case '/transaction':
            //   return MaterialPageRoute(
            //     builder: (_) => TransactionPage(),
            //   );
            //   break;
            // case '/customerprofile':
            //   return MaterialPageRoute(
            //     builder: (_) => CustomerProfile(),
            //   );
            //   break;
            default:
            //return _errorRoute();
          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
