import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/user.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/user_provider.dart';
import 'package:todo_list_riverpod/repositories/auth_repository.dart';
import 'package:todo_list_riverpod/views/screens/home.dart';
import 'package:todo_list_riverpod/views/screens/login.dart';
import 'package:todo_list_riverpod/views/widgets/model_notify.dart';

class LoginViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isLoginButtonEnabled = false;

  late User user;

  final Ref ref;
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository, this.ref) : super();

  void onEmailChanged(String email) {
    isEmailValid = email.isNotEmpty;
    isLoginButtonEnabled = isEmailValid && isPasswordValid;
  }

  void onPasswordChanged(String password) {
    isPasswordValid = password.isNotEmpty;
    isLoginButtonEnabled = isEmailValid && isPasswordValid;
  }

  Future<void> login(BuildContext context) async {
    try {
      await _authRepository
          .signInWithEmailAndPassword(
            emailController.text,
            passwordController.text,
            ref.read(fcmToken),
            // 'dTPjpzQ4S1yyr9C_b_w2J4:APA91bFOVXxLxo8I5VL7vh8UTPW2IntBSFwVAu4sdcf3SvZTevMpwLtLfUTdfCHgAa6WSVmiks7GNU5ad-szvK3f_nwD822k-NQs7q6pLO3o6LFxdGtZtQs',
            ref,
          )
          .then(
            (value) => ref.read(userProvider.notifier).state = value,
          );
      emailController.text = '';
      passwordController.text = '';
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ModelNotify(
          title: 'Login failed',
          message: e.toString(),
          type: 'error',
        ),
      );
    }
  }

  Future<void> signUp(BuildContext context) async {
    try {
      await _authRepository
          .signUp(
            nameController.text,
            emailController.text,
            passwordController.text,
            ref,
          )
          .then((value) => {
                ref.read(userProvider.notifier).state = value,
                nameController.text = '',
                emailController.text = '',
                passwordController.text = '',
                confirmPasswordController.text = '',
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()))
              });
      const ModelNotify(
        title: 'Sign up success',
        message: 'Sign up success',
        type: 'success',
      );
    } catch (e) {
      print('Sign up failed: $e');
      showDialog(
        context: context,
        builder: (context) => ModelNotify(
          title: 'Sign up failed',
          message: e.toString(),
          type: 'error',
        ),
      );
    }
  }

  Future<void> signOut(BuildContext context, String email) async {
    await _authRepository.signOut(email).then((value) {
      ref.read(userProvider.notifier).state = null;
      formKey.currentState?.reset();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    });
  }
}
