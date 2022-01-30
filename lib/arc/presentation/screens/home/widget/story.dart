import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/animation/animation_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/upload/upload_bloc.dart';
import 'package:hii_xuu_social/src/config/config.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:provider/src/provider.dart';

class StoryList extends StatefulWidget {
  const StoryList({Key? key}) : super(key: key);

  @override
  _StoryListState createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  final ScrollController _scrollController = ScrollController();
  bool _smallIcon = false;
  List<String>? _listStory = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleListenerScroll);
  }

  void _handleListenerScroll() {
    if (_scrollController.position.pixels > 0) {
      context.read<AnimationBloc>().add(const IconAddStoryChangeEvent(true));
    } else {
      context.read<AnimationBloc>().add(const IconAddStoryChangeEvent(false));
    }
  }

  void addStory() {
    context.read<UploadBloc>().add(OnPickStoryImageEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<AnimationBloc, AnimationState>(
          listener: (context, state) {
            if (state is IconAddStoryChangedState) {
              _smallIcon = state.smallIcon;
            }
          },
        ),
        BlocListener<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state is StoryImagePickedState) {
              if (state.imageFiles?.path != '') {
                navService.pushNamed(RouteKey.addStory, args: state.imageFiles);
              } else {}
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<AnimationBloc, AnimationState>(
        builder: (context, state) {
          if (state is IconAddStoryChangedState) {
            _smallIcon = state.smallIcon;
          }
          return Padding(
            padding: const EdgeInsets.all(Dimens.size15),
            child: Stack(
              children: [
                Container(
                  height: Dimens.size88,
                  color: theme.backgroundColor,
                  child: Row(
                    children: [
                      _buildBigAddStory(theme),
                      SizedBox(
                        width: _smallIcon == true ? 0 : Dimens.size15,
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoadedState) {
                            _listStory = state.listStory ?? [];
                          }
                          return Expanded(
                            child: ListView.separated(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      height: Dimens.size68,
                                      width: Dimens.size68,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: theme.primaryColor),
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(17),
                                          child: Image.network(
                                            _listStory?[index] ?? '',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: Dimens.size20),
                                    // SizedBox(
                                    //     height: Dimens.size15,
                                    //     child: Text(
                                    //       'user',
                                    //       style:
                                    //           theme.primaryTextTheme.bodyText2,
                                    //     ))
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: Dimens.size15);
                              },
                              itemCount: _listStory?.length ?? 0,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                _buildSmallAddStory(theme),
              ],
            ),
          );
        },
      ),
    );
  }

  GestureDetector _buildSmallAddStory(ThemeData theme) {
    return GestureDetector(
      onTap: addStory,
      child: AnimatedOpacity(
        opacity: _smallIcon ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.size16),
          child: Container(
            height: Dimens.size35,
            width: Dimens.size35,
            decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.5),
              child: Image.asset(MyImages.icAdd),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBigAddStory(ThemeData theme) {
    return Column(
      children: [
        GestureDetector(
          onTap: addStory,
          child: Container(
            height: Dimens.size68,
            width: _smallIcon == true ? 0 : Dimens.size68,
            decoration: BoxDecoration(
                color: theme.primaryColorLight,
                borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.size23),
              child: Image.asset(MyImages.icAdd),
            ),
          ),
        ),
        const SizedBox(height: Dimens.size20),
      ],
    );
  }
}
