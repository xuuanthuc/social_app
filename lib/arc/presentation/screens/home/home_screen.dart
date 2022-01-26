import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/widget/loading_home.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/widget/post_item.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  List<PostData> _listPost = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(InitHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoadingState) {}
        if (state is HomeLoadedState) {
          _listPost = state.listPost ?? [];
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const LoadingHome();
          }
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: const AppBarDesign(),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    color: theme.backgroundColor,
                  ),
                  Container(
                    color: theme.scaffoldBackgroundColor,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PostItem(item: _listPost[index]);
                      },
                      itemCount: _listPost.length,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}