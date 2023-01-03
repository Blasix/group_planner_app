import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/screens/auth/login.dart';
import 'package:group_planner_app/screens/auth/recovery_password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../consts/firebase_consts.dart';
import '../../fetch.dart';
import '../../services/global_methods.dart';
import '../../widgets/auth/apple.dart';
import '../../widgets/auth/google.dart';
import '../../widgets/auth/meta.dart';

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
            builder: (context) => const Fetch(),
          ),
        );
      } on FirebaseException catch (error) {
        GlobalMethods.dialogFailure(
          context: context,
          title: 'Oh snap!',
          message: '${error.message}',
        );
        setState(() {
          _isLoading = false;
        });
        return;
      } catch (error) {
        GlobalMethods.dialogFailure(
          context: context,
          title: 'Oh snap!',
          message: '$error',
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
                          AppLocalizations.of(context)!.registerinfo1,
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
                          AppLocalizations.of(context)!.registerinfo2,
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
                            validator: ValidationBuilder(
                                    localeName: AppLocalizations.of(context)!
                                        .localeName)
                                .build(),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: AppLocalizations.of(context)!.username,
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
                            validator: ValidationBuilder(
                                    localeName: AppLocalizations.of(context)!
                                        .localeName)
                                .email()
                                .maxLength(50)
                                .build(),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.mail, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: AppLocalizations.of(context)!.email,
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
                            validator: ValidationBuilder(
                                    localeName: AppLocalizations.of(context)!
                                        .localeName)
                                .minLength(6)
                                .maxLength(20)
                                .regExp(RegExp('(?=.*?[A-Z])'),
                                    AppLocalizations.of(context)!.noUppercase)
                                .regExp(RegExp('(?=.*?[0-9])'),
                                    AppLocalizations.of(context)!.noNumber)
                                .build(),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.vpn_key, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: AppLocalizations.of(context)!.password,
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
                                return AppLocalizations.of(context)!.noAnything;
                              }
                              if (_confPassTextController.text !=
                                  _passTextController.text) {
                                return AppLocalizations.of(context)!.noMatch;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.vpn_key, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText:
                                  AppLocalizations.of(context)!.confirmPassword,
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
                                  AppLocalizations.of(context)!.forgotPassword,
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
                        child: Text(
                          AppLocalizations.of(context)!.register,
                          style: const TextStyle(
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
                          AppLocalizations.of(context)!.orContinueWith,
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
                      children: const [
                        GoogleButton(),
                        SizedBox(
                          width: 30,
                        ),
                        AppleButton(),
                        SizedBox(
                          width: 30,
                        ),
                        MetaButton(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.alreadyMember,
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
                              AppLocalizations.of(context)!.signIn,
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
