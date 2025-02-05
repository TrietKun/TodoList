import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/todo_provider.dart';
import 'package:todo_list_riverpod/providers/user_provider.dart';
import 'package:todo_list_riverpod/providers/ws_provider.dart';
import 'package:todo_list_riverpod/views/screens/admin.dart';
import 'package:todo_list_riverpod/views/screens/list_friend.dart';
import 'package:todo_list_riverpod/views/screens/list_notification.dart';
import 'package:todo_list_riverpod/views/screens/setting.dart';
import 'package:todo_list_riverpod/views/widgets/item_list_todo.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late PageController _pageController;
  int _selectedIndex = 0;

  Offset offset = const Offset(
    0,
    0,
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(websoketViewmodelProvider)
          .connect(ref.read(userProvider)!.id ?? "", context);
      ref
          .read(todoViewModelProvider)
          .fetchTodos(ref.read(userProvider)!.id ?? "");
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final todos = ref.watch(todoProvider);
    final userViewModel = ref.watch(userViewModelProvider);
    final todoViewModel = ref.watch(todoViewModelProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.brown[400],
            elevation: 0,
            title: Text(
              (user != null ? (user.name ?? 'Guest').toUpperCase() : 'GUEST') +
                  (user?.role == 'admin' ? '@admin' : ''),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  userViewModel.openModelSearchFriend(context);
                },
                icon: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_active_outlined,
                    color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListNotification()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Setting()),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        // decoration: BoxDecoration(color: Colors.brown[400]),
                        child: todos.isEmpty
                            ? Center(
                                child: Text(
                                  'No Todos Available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: ItemListTodo(todo: todos[index]),
                                  );
                                },
                                itemCount: todos.length,
                              ),
                      ),
                      Positioned(
                        right: offset.dx + 10,
                        bottom: offset.dy + 30,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              offset -= details.delta;
                              if (offset.dx < 0) {
                                offset = Offset(0, offset.dy);
                              }
                              if (offset.dy < 0) {
                                offset = Offset(offset.dx, 0);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.brown[400],
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: FloatingActionButton(
                              backgroundColor: Colors.transparent,
                              shape: const CircleBorder(),
                              onPressed: () {
                                todoViewModel.openModalAddNewTodo(context);
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const ListFriend(),
                  user?.role == 'admin'
                      ? const Admin()
                      : Center(
                          child: Text(
                            'You are not an admin',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.brown[400],
            selectedItemColor: Colors.white,
            selectedIconTheme: const IconThemeData(
              size: 30,
              color: Colors.white,
            ),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedFontSize: 14,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedIconTheme: const IconThemeData(
              size: 20,
              color: Colors.white,
            ),
            currentIndex: _selectedIndex,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon:
                    //cupertino style icon
                    Icon(CupertinoIcons.chat_bubble_2_fill,
                        color: Colors.white),
                label: 'Chat',
              ),
              if (user?.role == 'admin')
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.white),
                  label: 'Admin',
                ),
            ],
            onTap: _onItemTapped,
          )),
    );
  }
}
