import 'package:dalell/constants/routes.dart';
import 'package:dalell/enums/menu_action.dart';
import 'package:dalell/services/auth/auth_services.dart';
import 'package:dalell/services/crud/note_service.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final NoteService _noteService;
  String get userEmail => AuthServices.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    _noteService.open();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

  Menu? selectedMenu;
  String menuBar = 'Menu';
  String selectedPage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main page'),
        backgroundColor: Colors.blue[500],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<Menu>(
            initialValue: selectedMenu,
            onSelected: (item) async {
              setState(() {
                selectedMenu = item;
              });
              switch (item) {
                case Menu.logout:
                  final showlogout = await showLogOutDialog(context);

                  if (showlogout) {
                    await AuthServices.firebase().logout();
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                case Menu.newNote:
                  Navigator.of(context).pushNamed(newNoteRoute);

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
                  value: Menu.newNote,
                  child: ListTile(
                    leading: Icon(Icons.note_add_outlined),
                    title: Text('NewNote'),
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
                  value: Menu.preview,
                  child: ListTile(
                    leading: Icon(Icons.visibility_outlined),
                    title: Text('Preview'),
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
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                setState(() {
                  selectedPage = 'Profile';
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  selectedPage = 'Settings';
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
          future: _noteService.getorCreateuser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _noteService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('Your note will appear here');
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );

              default:
                return const CircularProgressIndicator();
            }
          }),
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
