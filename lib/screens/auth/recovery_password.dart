import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../consts/firebase_consts.dart';
import '../../services/global_methods.dart';

class PassRecScreen extends StatefulWidget {
  const PassRecScreen({Key? key}) : super(key: key);

  @override
  State<PassRecScreen> createState() => _PassRecScreenState();
}

class _PassRecScreenState extends State<PassRecScreen> {
  final _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  Future<void> _submitFormOnLogin(context) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance
            .setLanguageCode(AppLocalizations.of(context)!.localeName);
        await authInstance.sendPasswordResetEmail(
            email: _emailTextController.text.toLowerCase().trim());
        GlobalMethods.dialog(
          context: context,
          title: 'Send!',
          message: 'A reset password email has been succesfully send',
        );
      } on FirebaseAuthException catch (error) {
        GlobalMethods.dialogFailure(
          context: context,
          message: '${error.message}',
        );
        setState(() {
          _isLoading = false;
        });
        return;
      } catch (error) {
        GlobalMethods.dialogFailure(
          context: context,
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
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(IconlyLight.arrow_left_2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 34,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          AppLocalizations.of(context)!.forgotPasswordInfo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: () {
                          _submitFormOnLogin(context);
                        },
                        validator: ValidationBuilder(
                                localeName:
                                    AppLocalizations.of(context)!.localeName)
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
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
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
                          AppLocalizations.of(context)!.resetPassword,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
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
