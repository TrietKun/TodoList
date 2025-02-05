import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/viewmodels/websoket_viewmodel.dart';

final websoketViewmodelProvider =
    Provider((ref) => WebsoketViewmodel(ref: ref));
