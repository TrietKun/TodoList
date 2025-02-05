import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/chat_provider.dart';
import 'package:todo_list_riverpod/providers/conversation_provider.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/views/screens/conversation_detail.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  final ScrollController _scrollController = ScrollController();
  bool _emojiPicker = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationViewmodelProvider).init(
            ref.read(userProvider)!.id ?? "",
            ref.read(friendProvider)!.id,
          );
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = ref.watch(chatViewModelProvider);
    final conversationviewmodel = ref.read(conversationViewmodelProvider);
    final user = ref.read(userProvider);
    final conversation = ref.watch(conversationprovider);
    final listmessage = ref.watch(listMessageProvider);
    final friend = ref.watch(friendProvider);
    final sateLoadMore =
        ref.watch(conversationViewmodelProvider).isLoadMoreOldMessage;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listmessage.isNotEmpty && sateLoadMore == false) {
        _scrollToBottom();
        return;
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == 0) {
        ref.read(conversationViewmodelProvider).isLoadMoreOldMessage = true;
        ref.read(conversationViewmodelProvider).getMessages(
              ref.read(conversationprovider)!.id,
            );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        actions: [
          friend!.conversation.conversationStatus != 'block' &&
                  friend.conversation.conversationStatus != 'blocked'
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.call, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.videocam, color: Colors.white),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConversationDetail()));
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
        title: Text(friend.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
        elevation: 2,
      ),
      body: conversationviewmodel.isFetching
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                friend.conversation.conversationStatus.toString() != 'friend'
                    ? Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info, color: Colors.brown[400]),
                            const SizedBox(width: 8),
                            chatViewModel.renderConversationStatus(
                              context,
                              friend.conversation.conversationStatus.toString(),
                              user!.id ?? "",
                              friend.id,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    color: Colors.white,
                    child: ListView.builder(
                      controller: _scrollController, // Gắn ScrollController
                      itemCount: listmessage.length,
                      itemBuilder: (context, index) {
                        final message = listmessage[index];
                        final isSentByMe = conversationviewmodel.isSentByMe(
                            message, user!.id ?? "");
                        return Align(
                          alignment: isSentByMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 8.0,
                            ),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color:
                                  isSentByMe ? Colors.brown[400] : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isSentByMe
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                                bottomRight: isSentByMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.message,
                                  style: TextStyle(
                                    color: isSentByMe
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${message.timestamp.hour}:${message.timestamp.minute}",
                                  style: TextStyle(
                                    color: isSentByMe
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: friend.conversation.conversationStatus != 'block' &&
                          friend.conversation.conversationStatus != 'blocked'
                      ? Row(
                          children: [
                            _emojiPicker == false
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _emojiPicker = !_emojiPicker;
                                      });
                                    },
                                    icon: const Icon(Icons.emoji_emotions),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _emojiPicker = !_emojiPicker;
                                      });
                                    },
                                    icon: const Icon(Icons.keyboard),
                                  ),
                            Expanded(
                              child: TextField(
                                controller:
                                    conversationviewmodel.messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type your message...',
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade500),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                conversationviewmodel.sendMessage(
                                  conversationviewmodel.messageController.text,
                                  user!.id ?? "",
                                  friend.id,
                                  conversation!.id,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(14.0),
                                backgroundColor: Colors.brown[400],
                              ),
                              child:
                                  const Icon(Icons.send, color: Colors.white),
                            ),
                          ],
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(
                              bottom: 16, left: 16, right: 16),
                          child: const Text(
                            textAlign: TextAlign.center,
                            'This conversation has been blocked',
                          ),
                        ),
                ),
                _emojiPicker == true
                    ? EmojiPicker(
                        textEditingController:
                            conversationviewmodel.messageController,
                        config: Config(
                          height: 256,
                          checkPlatformCompatibility: true,
                          emojiViewConfig: EmojiViewConfig(
                            emojiSizeMax: 28 *
                                (foundation.defaultTargetPlatform ==
                                        TargetPlatform.iOS
                                    ? 1.20
                                    : 1.0),
                          ),
                          viewOrderConfig: const ViewOrderConfig(
                            top: EmojiPickerItem.categoryBar,
                            middle: EmojiPickerItem.emojiView,
                            bottom: EmojiPickerItem.searchBar,
                          ),
                          skinToneConfig: const SkinToneConfig(),
                          categoryViewConfig: const CategoryViewConfig(),
                          bottomActionBarConfig: const BottomActionBarConfig(
                            enabled: false,
                          ),
                          searchViewConfig: const SearchViewConfig(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
    );
  }
}
