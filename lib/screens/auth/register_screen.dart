import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final ValueNotifier<bool> passwordObscureNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordObscureNotifier =
      ValueNotifier(true);
  final ValueNotifier<bool> isFieldValidNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateFields);
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
    confirmPasswordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateFields() {
    final isValid = _registerFormKey.currentState?.validate() ?? false;
    isFieldValidNotifier.value = isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Create Your Account",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(
                          controller: nameController,
                          labelText: 'Name',
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            } else if (value.length < 4) {
                              return 'Name must be at least 4 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            } else if (!RegExp(
                                    r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<bool>(
                          valueListenable: passwordObscureNotifier,
                          builder: (context, passwordObscure, child) {
                            return _buildTextField(
                              controller: passwordController,
                              labelText: 'Password',
                              obscureText: passwordObscure,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  passwordObscureNotifier.value =
                                      !passwordObscureNotifier.value;
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<bool>(
                          valueListenable: confirmPasswordObscureNotifier,
                          builder: (context, confirmPasswordObscure, child) {
                            return _buildTextField(
                              controller: confirmPasswordController,
                              labelText: 'Confirm Password',
                              obscureText: confirmPasswordObscure,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please re-enter your password';
                                } else if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  confirmPasswordObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  confirmPasswordObscureNotifier.value =
                                      !confirmPasswordObscureNotifier.value;
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        ValueListenableBuilder<bool>(
                          valueListenable: isFieldValidNotifier,
                          builder: (context, isValid, child) {
                            return ElevatedButton(
                              onPressed: isValid
                                  ? () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Registration Complete'),
                                        ),
                                      );
                                      _registerFormKey.currentState?.reset();
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                foregroundColor: isValid
                                    ? Colors.black87
                                    : Colors.grey,
                              ),
                              child: const Text("Sign Up"),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I have an account? "),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    required FormFieldValidator<String> validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onChanged: (_) => _validateFields(),
    );
  }
}
