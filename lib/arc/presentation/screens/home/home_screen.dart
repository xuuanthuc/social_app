import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/widget/loading_home.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/widget/post_item.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/widget/story.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PostData> _listPost = [];
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    if (StaticVariable.listPost != null) {
      _listPost = StaticVariable.listPost ?? [];
    } else {
      context.read<HomeBloc>().add(InitHomeEvent());
    }
  }

  void _onRefresh() async {
    context.read<HomeBloc>().add(InitHomeEvent());
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoadingState) {

        }
        if (state is HomeLoadedState) {
          _listPost = state.listPost ?? [];
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const LoadingHome();
          }
          return Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                settings: settings,
                builder: (materialContext) {
                  return Scaffold(
                    backgroundColor: theme.backgroundColor,
                    appBar: AppBarDesign(
                      hasAction1: false,
                      hasLeading: true,
                      hasAction2: true,
                      centerTitle: true,
                      imgAction1: MyImages.icCameraSelected,
                      imgAction2: MyImages.icSend,
                      imgLeading: MyImages.icCameraSelected,
                      onTapLeading: () {
                        context.read<MainBloc>().add(OnChangePageEvent(Constants.page.camera));
                      },
                      onTapAction1: () {
                        context.read<MainBloc>().add(OnChangePageEvent(Constants.page.camera));
                      },
                      onTapAction2: () {
                        context.read<MainBloc>().add(OnChangePageEvent(Constants.page.chat));
                      },
                    ),
                    body: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: false,
                      onRefresh: _onRefresh,
                      physics: const BouncingScrollPhysics(),
                      header: const WaterDropMaterialHeader(),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const StoryList(),
                            Container(
                              color: theme.scaffoldBackgroundColor,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if((_listPost[index].images ?? []).isEmpty && (_listPost[index].content ?? '').isEmpty){
                                    return Container();
                                  } else {
                                    return PostItem(item: _listPost[index]);
                                  }
                                },
                                itemCount: _listPost.length,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
