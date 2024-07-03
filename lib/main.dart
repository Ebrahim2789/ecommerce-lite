import 'package:dalell/firebase_options.dart';
import 'package:dalell/views/drawer_demo.dart';
import 'package:dalell/views/login_view.dart';
import 'package:dalell/views/register_view.dart';
import 'package:dalell/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',

    theme: ThemeData(useMaterial3: true),
    home: const HomePage(),
    // initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/login/': (context) => const LoginView(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/register/': (context) => const RegisterView(),
      '/notes/': (context) => const MainPage(),
      '/menu/':(context)=>const DrawerDemo(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized;
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // checking user

            final user = FirebaseAuth.instance.currentUser;
            // final emailVerified=user?.emailVerified??false;

            if (user != null) {
              if (user.emailVerified) {
                return const MainPage();
              } else {
                // devtools.log(user);
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          // return const Text("Done");

          default:
            return const CircularProgressIndicator();
          // return const Text('Loading ....');
        }
      },
    );
  }
}

enum MenuAction { logout }

enum Menu { logout, preview, share, getLink, remove, download }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Menu? selectedMenu;
  String menuBar='Menu';
    String selectedPage='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      //   leading:IconButton(icon: const Icon(Icons.menu),
      //   tooltip: menuBar,onPressed: ()async{
      // // final menu=  await DrawerDemo();\
      //     // Navigator.of(context).pushNamedAndRemoveUntil('/menu/', (route)=>false, );
   
      
      //   },),
        title: const Text('Main page'),

        backgroundColor: Colors.blue[500],
        
        
        actions: [
          PopupMenuButton<Menu>(
            initialValue: selectedMenu,
            onSelected: (item) async {
              setState(() {
                selectedMenu = item;
              });
              devtools.log(item.toString());
              switch (item) {
                case Menu.logout:
                  final showlogout = await showLogOutDialog(context);

                  if (showlogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_)=>false, );
                  }
                case Menu.download:
                  break;

                case Menu.preview:
                  break;
                case Menu.share:
                  break;
                case Menu.getLink:
                  break;
                case Menu.remove:
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<Menu>(
                  value: Menu.logout,
                  child: ListTile(
                      title: Text('Log out'),
                      leading: Icon(Icons.logout_outlined)),

                      
                ),
                PopupMenuItem<Menu>(
                  value: Menu.preview,
                  child: ListTile(
                    leading: Icon(Icons.visibility_outlined),
                    title: Text('Preview'),
                  ),
                ),
                PopupMenuItem<Menu>(
                  value: Menu.share,
                  child: ListTile(
                    leading: Icon(Icons.share_outlined),
                    title: Text('Share'),
                  ),
                ),
                PopupMenuItem<Menu>(
                  value: Menu.getLink,
                  child: ListTile(
                    leading: Icon(Icons.link_outlined),
                    title: Text('Get link'),
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<Menu>(
                  value: Menu.remove,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Remove'),
                  ),
                ),
                PopupMenuItem<Menu>(
                  value: Menu.download,
                  child: ListTile(
                    leading: Icon(Icons.download_outlined),
                    title: Text('Download'),
                  ),
                ),
              ];
            },
          )
        ],
      ),

drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () {
                setState(() {
                  selectedPage = 'Messages';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                setState(() {
                  selectedPage = 'Profile';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  selectedPage = 'Settings';
                });
              },
            ),
          ],
        ),
      ),

      body: Text('Page: $selectedPage'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text("Are you sure going to log out"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}
