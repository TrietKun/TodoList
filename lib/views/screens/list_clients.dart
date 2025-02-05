import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/user_provider.dart';

class ListClients extends ConsumerStatefulWidget {
  const ListClients({super.key, required this.type});
  final String type;

  @override
  ConsumerState<ListClients> createState() => _ListClientsState();
}

class _ListClientsState extends ConsumerState<ListClients> {
  @override
  Widget build(BuildContext context) {
    var listUser = ref.watch(listUserProvider);
    if (widget.type == 'member') {
      listUser = listUser.where((user) => user.isMember == true).toList();
    }

    return ListView.builder(
      itemCount: listUser.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: ListTile(
              title: Text(
                listUser[index].name ?? 'No name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(listUser[index].email ?? 'No email'),
              trailing: widget.type == 'client'
                  ? Icon(
                      listUser[index].isMember == true
                          ? Icons.wallet_membership_sharp
                          : null,
                      color: listUser[index].isMember == true
                          ? Colors.green
                          : Colors.transparent,
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
