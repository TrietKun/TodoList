import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/repositories/firebase_notify_repository.dart';
import 'package:todo_list_riverpod/services/firebase_notify_service.dart';
import 'package:todo_list_riverpod/viewmodels/admin_viewmodel.dart';


final firebaseNotifyService = Provider((ref) => FirebaseNotifyService()); 

final firebaseNotifyRepositoryProvider = Provider((ref) {
  final service = ref.read(firebaseNotifyService);
  return FirebaseNotifyRepository(service);
});

final adminViewModelProvider = Provider((ref) {
  final firebaseNotifyRepository = ref.read(firebaseNotifyRepositoryProvider);
  return AdminViewmodel(firebaseNotifyRepository);
});