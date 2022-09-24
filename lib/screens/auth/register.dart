import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/screens/auth/login.dart';
import 'package:group_planner_app/screens/auth/recovery_password.dart';

import '../../consts/firebase_consts.dart';
import '../../services/global_methods.dart';
import '../btm_bar.dart';
import 'other_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _confPassTextController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _confPassFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  var _confObscureText = true;

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _confPassTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _confPassFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin(context) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final uid = user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'username': _nameTextController.text,
          'email': _emailTextController.text,
          'profilePictureUrl': '',
          'createdAt': Timestamp.now(),
          'selectedTeam': '',
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BottomBarScreen(),
          ),
        );
      } on FirebaseException catch (error) {
        GlobalMethods.dialog(
          context: context,
          title: 'On snap!',
          message: '${error.message}',
          contentType: ContentType.failure,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      } catch (error) {
        GlobalMethods.dialog(
          context: context,
          title: 'On snap!',
          message: '$error',
          contentType: ContentType.failure,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    const SizedBox(),
                    Column(
                      children: [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 40,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Make an account to continue!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _nameTextController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            validator: ValidationBuilder().build(),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Username",
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.4),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            focusNode: _emailFocusNode,
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _emailTextController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            validator: ValidationBuilder()
                                .email()
                                .maxLength(50)
                                .build(),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.mail, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Email",
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.4),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_confPassFocusNode),
                            cursorColor: Theme.of(context).primaryColor,
                            focusNode: _passFocusNode,
                            controller: _passTextController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText,
                            validator: ValidationBuilder()
                                .minLength(6)
                                .maxLength(20)
                                .regExp(RegExp('(?=.*?[A-Z])'),
                                    'Must contain at least one uppercase letter')
                                .regExp(RegExp('(?=.*?[0-9])'),
                                    'Must contain at least one number')
                                .build(),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.vpn_key, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Password",
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.4),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: _obscureText
                                    ? const Icon(Icons.visibility,
                                        color: Colors.grey)
                                    : const Icon(Icons.visibility_off,
                                        color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onEditingComplete: () {
                              _submitFormOnLogin(context);
                            },
                            cursorColor: Theme.of(context).primaryColor,
                            focusNode: _confPassFocusNode,
                            controller: _confPassTextController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _confObscureText,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is required";
                              }
                              if (_confPassTextController.text !=
                                  _passTextController.text) {
                                return "Passwords don't match";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.vpn_key, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "Confirm password",
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.4),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _confObscureText = !_confObscureText;
                                  });
                                },
                                icon: _confObscureText
                                    ? const Icon(Icons.visibility,
                                        color: Colors.grey)
                                    : const Icon(Icons.visibility_off,
                                        color: Colors.grey),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PassRecScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Recovery password',
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.4),
                                    fontSize: 16,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 3),
                        onPressed: () {
                          _submitFormOnLogin(context);
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Or continue with',
                          style: TextStyle(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.4),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OtherButton(
                            function: () {},
                            buttonImagePath: 'assets/images/auth/google.png'),
                        const SizedBox(
                          width: 30,
                        ),
                        OtherButton(
                            function: () {},
                            buttonImagePath: 'assets/images/auth/apple.png'),
                        const SizedBox(
                          width: 30,
                        ),
                        OtherButton(
                            function: () {},
                            buttonImagePath: 'assets/images/auth/meta.png'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already an account?",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.4),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign in',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.blue.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
