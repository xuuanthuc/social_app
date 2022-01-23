import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/src/config/config.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import '../../../../arc/presentation/blocs/splash/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        if(state is GoToLoginState){
          await Future.delayed(const Duration(seconds: 2));
          navService.pushNamed(RouteKey.login);
        }
        if(state is GotoHomeState){
          await Future.delayed(const Duration(seconds: 2));
          navService.pushNamed(RouteKey.main);
        }
      },
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }
}
