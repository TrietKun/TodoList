import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/user_provider.dart';
import 'package:todo_list_riverpod/views/screens/list_clients.dart';
import 'package:todo_list_riverpod/views/screens/notify_to_client.dart';

class Admin extends ConsumerStatefulWidget {
  const Admin({super.key});

  @override
  ConsumerState createState() => _AdminState();
}

class _AdminState extends ConsumerState<Admin> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userViewModelProvider).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(icon: Icon(Icons.group), text: 'Clients'),
              Tab(icon: Icon(Icons.wallet_membership_sharp), text: 'Members'),
              Tab(icon: Icon(Icons.notifications), text: 'Notifications'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
          ),
          Flexible(
            child: TabBarView(
              controller: tabController,
              children: const [
                ListClients(
                  type: 'client',
                ),
                ListClients(
                  type: 'member',
                ),
                NotifyToClient(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
