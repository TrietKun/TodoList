import 'package:flutter/material.dart';

class ModelNotify extends StatefulWidget {
  const ModelNotify({super.key, this.title, this.message, required this.type});
  final String? title;
  final String? message;
  final String type;

  @override
  State<ModelNotify> createState() => _ModelNotifyState();
}

class _ModelNotifyState extends State<ModelNotify> {
  @override
  Widget build(BuildContext context) {
    print('typeeee: ${widget.type}');
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Chiều rộng bạn muốn
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              //nếu là unfriend thì sẽ hiển thị Unfriend hoặc nếu là cancel thì sẽ hiển thị Cancel Friend Request, còn khác 2 cái trên thì sẽ hiển thị title
              widget.type == 'unfriend'
                  ? 'Unfriend'
                  : widget.type == 'cancel'
                      ? 'Cancel Friend Request'
                      : widget.type == 'decline'
                          ? 'Decline Friend Request'
                          : widget.title!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[400],
                    fontSize: 20.0,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              widget.type == 'unfriend'
                  ? 'You have unfriended this person'
                  : widget.type == 'cancel'
                      ? 'You have canceled the friend request'
                      : widget.type == 'decline'
                          ? 'You have declined the friend request'
                          : widget.message!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.brown[400],
                    fontSize: 16.0,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[400],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
