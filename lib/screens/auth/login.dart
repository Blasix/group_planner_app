import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/fetch.dart';
import 'package:group_planner_app/widgets/auth/apple.dart';
import 'package:group_planner_app/widgets/auth/google.dart';
import 'package:group_planner_app/widgets/auth/meta.dart';
import 'package:group_planner_app/screens/auth/recovery_password.dart';
import 'package:group_planner_app/screens/auth/register.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../consts/firebase_consts.dart';
import '../../services/global_methods.dart';

//TODO in all auth screens: add translations to Validatiors (dutch not yet implemented), so wait for that or do it myself

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;

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
        await authInstance.signInWithEmailAndPassword(
          email: _emailTextController.text.toLowerCase().trim(),
          password: _passTextController.text.trim(),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Fetch(),
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
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
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
                          AppLocalizations.of(context)!.signInInfo1,
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
                          AppLocalizations.of(context)!.signInInfo2,
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
                            onEditingComplete: () {
                              _submitFormOnLogin(context);
                            },
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
                          AppLocalizations.of(context)!.signIn,
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
                          AppLocalizations.of(context)!.notMember,
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
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.registerNow,
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
