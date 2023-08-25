import 'package:core/core.dart'
    show BlocConsumer, BlocProvider, RoutePage;
import 'package:core/di/app_di.dart';
import 'package:core/services/auth_service.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:sign_up_screen/src/bloc/sign_up_bloc.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpBloc(
        emailSignUpUseCase: appLocator<EmailSignUpUseCase>(),
        saveUserUseCase: appLocator<SaveUserUseCase>(),
        checkUserUseCase: appLocator<CheckUserUseCase>(),
        appRouter: appLocator<AppRouter>(),
        authService: appLocator<AuthService>(),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            body: BlocConsumer<SignUpBloc, SignUpState>(
              listener: (BuildContext context, SignUpState state) {
                if (state.errorMessage.isNotEmpty) {
                  showAppSnackBar(context: context, title: state.errorMessage);
                }
              },
              builder: (BuildContext context, SignUpState state) {
                if (state.isLoading) {
                  return const AppLoadingCircle();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(bottom: constraints.minHeight / 18),
                      child: Text(
                        AppStrConstants.signUpPageTitle,
                        style: AppFonts.normal30.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: constraints.minWidth / 14,
                        right: constraints.minWidth / 14,
                        bottom: constraints.minHeight / 60,
                      ),
                      child: AppTextField(
                        label: AppStrConstants.emailTitle,
                        textController: _emailController,
                        isObscure: false,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: constraints.minWidth / 14,
                        right: constraints.minWidth / 14,
                        bottom: constraints.minHeight / 15,
                      ),
                      child: AppTextField(
                        label: AppStrConstants.passwordTitle,
                        textController: _passwordController,
                        isObscure: true,
                      ),
                    ),
                    SizedBox(
                      width: constraints.minWidth / 1.15,
                      height: constraints.minHeight / 20,
                      child: AppButton(
                        text: AppStrConstants.createAccount,
                        handler: () => BlocProvider.of<SignUpBloc>(context).add(
                          SignUpEvent(
                            data: EmailSignUpModel(
                              name: '',
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
