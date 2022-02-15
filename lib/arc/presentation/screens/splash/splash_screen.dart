import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import '../../../../src/config/config.dart';
import '../../../../src/utilities/navigation_service.dart';
import '../../../../arc/presentation/blocs/splash/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(InitSplashEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        if (state is GoToLoginState) {
          // await Future.delayed(const Duration(seconds: 2));
          navService.pushNamed(RouteKey.login);
        }
        if (state is GotoHomeState) {
          navService.pushNamed(RouteKey.main);
        }
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Image.asset(
                MyImages.splashText,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                MyImages.splashIcon,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
