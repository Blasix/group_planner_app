import 'package:flutter/material.dart';
import 'package:group_planner_app/screens/auth/other_button.dart';
import 'package:group_planner_app/screens/auth/recovery_password.dart';
import 'package:group_planner_app/screens/auth/register.dart';
import 'package:group_planner_app/screens/btm_bar.dart';
import 'package:form_validator/form_validator.dart';

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

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  void _submitFormOnLogin() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                        'Hello Again!',
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
                        "Welcome back you've been missed!",
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
                          validator:
                              ValidationBuilder().email().maxLength(50).build(),
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
                          onEditingComplete: () {
                            _submitFormOnLogin();
                          },
                          cursorColor: Theme.of(context).primaryColor,
                          focusNode: _passFocusNode,
                          controller: _passTextController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _obscureText,
                          validator: ValidationBuilder()
                              .minLength(5)
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
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PassRecScreen(),
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
                          elevation: 3,
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        _submitFormOnLogin();
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomBarScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Sign in',
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
                        "Not a member?",
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
                            'Register now',
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
    );
  }
}
