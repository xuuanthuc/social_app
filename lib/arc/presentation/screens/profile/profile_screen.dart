import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/profile/profile_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/home/widget/post_item.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/edit_my_profile.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/widget/full_image.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/widget/loading_my_profile.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:hii_xuu_social/src/config/config.dart';
import 'package:hii_xuu_social/src/preferences/app_preference.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData _user = UserData();
  final List<PostData> _listPhotos = [];
  int _currentIndexTab = 0;

  @override
  void initState() {
    super.initState();
    context
        .read<ProfileBloc>()
        .add(InitProfileUserEvent(StaticVariable.myData?.userId ?? ''));
  }

  void goToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const EditProfileScreen();
        },
      ),
    );
  }

  Future<void> _showSettingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.size50),
          child: AlertDialog(
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Theme.of(context).backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Dimens.size30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: SizedBox(
                    height: Dimens.size80,
                    width: Dimens.size80,
                    child: _user.imageUrl == ''
                        ? Image.asset(MyImages.defaultAvt)
                        : Image.network(
                            _user.imageUrl ?? '',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: Dimens.size20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.size20),
                  child: Text(
                    'Are you sure you want to logout?',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Dimens.size10),
                const Divider(),
                GestureDetector(
                  onTap: () {
                    StaticVariable.listPost = null;
                    StaticVariable.myData = null;
                    AppPreference().setVerificationID(null);
                    navService.pushNamed(RouteKey.login);
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: Dimens.size30,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'Logout',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                    height: Dimens.size30,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: Dimens.size10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is InitProfileSuccessState) {
              _user = state.user;

              for (PostData post in state.user.posts ?? []) {
                if (post.images!.isNotEmpty) {
                  _listPhotos.add(post);
                }
              }
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is DeletePostSuccessState) {
              _listPhotos
                  .removeWhere((element) => element.postId == state.postId);
              _user.posts
                  ?.removeWhere((element) => element.postId == state.postId);
            }
          },
        ),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is LoadingInitProfileState) {
                return const LoadingProfile();
              }
              final theme = Theme.of(context);
              final size = MediaQuery.of(context).size;
              return Scaffold(
                backgroundColor: theme.backgroundColor,
                appBar: AppBarDesign(
                  hasAction1: false,
                  hasAction2: true,
                  hasLeading: true,
                  imgAction1: MyImages.icAddUser,
                  imgAction2: MyImages.icSettingSelected,
                  imgLeading: MyImages.icAddUser,
                  centerTitle: true,
                  title: Text(
                    StaticVariable.myData?.fullName ??
                        Constants.fullNameDefault,
                    style: theme.textTheme.headline2,
                  ),
                  onTapAction1: () {
                    context
                        .read<MainBloc>()
                        .add(OnChangePageEvent(Constants.page.search));
                  },
                  onTapAction2: () {
                    _showSettingDialog();
                  },
                  onTapLeading: () {
                    context
                        .read<MainBloc>()
                        .add(OnChangePageEvent(Constants.page.search));
                  },
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: AnimationLimiter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 300),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          const SizedBox(height: Dimens.size25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: Dimens.size20),
                              _buildAvatar(theme),
                              const SizedBox(width: Dimens.size15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildUserName(theme),
                                  const SizedBox(height: Dimens.size12),
                                  followingWidget(theme),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: Dimens.size15),
                          _buildFullName(theme),
                          const SizedBox(height: Dimens.size5),
                          _buildBio(size, theme),
                          const SizedBox(height: Dimens.size20),
                          _buildCellCountFollow(theme),
                          _buildTabShowPost(theme),
                          switchTypeListPost(_currentIndexTab),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget switchTypeListPost(int index) {
    Widget newWidget = Container();
    switch (index) {
      case 0:
        newWidget = (_user.posts ?? []).isEmpty
            ? Container()
            : _buildGridImage();
        break;
      case 1:
        newWidget = (_user.posts ?? []).isEmpty
            ? Container()
            : _buildListPost();
        break;
      case 2:
        newWidget = Container();
        break;
    }
    return newWidget;
  }

  Padding _buildTabShowPost(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.size15),
      child: Container(
        height: Dimens.size50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: theme.shadowColor),
        child: Row(
          children: [
            _tab(
                index: 0,
                controller: _currentIndexTab,
                label: TranslationKey.photos.tr(),
                onTap: () {
                  setState(() {
                    _currentIndexTab = 0;
                  });
                }),
            _tab(
                index: 1,
                controller: _currentIndexTab,
                label: TranslationKey.posts.tr(),
                onTap: () {
                  setState(() {
                    _currentIndexTab = 1;
                  });
                }),
            _tab(
                index: 2,
                controller: _currentIndexTab,
                label: TranslationKey.save.tr(),
                onTap: () {
                  setState(() {
                    _currentIndexTab = 2;
                  });
                }),
          ],
        ),
      ),
    );
  }

  Widget _tab(
      {required int index,
      required int controller,
      String? label,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: Dimens.size50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: index == controller
                  ? LinearGradient(
                      colors: [
                        theme.primaryColor,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                label ?? '',
                style: index == controller
                    ? theme.primaryTextTheme.button
                    : theme.primaryTextTheme.headline4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.size20, vertical: Dimens.size5),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        crossAxisCount: 3,
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     childAspectRatio: 1 / 1,
        //     crossAxisSpacing: 15,
        //     mainAxisSpacing: 15,
        //     crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () {
                      navService.push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (_, __, ___) =>  FullImageScreen(
                              image: _listPhotos[index].images ?? []),
                        ),
                      );
                    },
                    child: Hero(
                      tag: _listPhotos[index].images?.first ?? '',
                      child: Image.network(
                        _listPhotos[index].images?.first ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              (_listPhotos[index].images ?? []).length > 1
                  ? Positioned(
                      top: Dimens.size10,
                      right: Dimens.size10,
                      child: SvgPicture.asset(MyImages.icStack))
                  : Container()
            ],
          );
        },
        itemCount: _listPhotos.length,
      ),
    );
  }

  Widget _buildListPost() {
    return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.size5),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: PostItem(
                        item: _user.posts![index],
                      ));
                },
                itemCount: _user.posts?.length,
              ),
            ),
          );
  }

  Row followingWidget(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => goToEditProfile(),
          child: Container(
            height: Dimens.size35,
            // width: Dimens.size150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: theme.primaryColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: Dimens.size20,
                ),
                Text(
                  TranslationKey.editProfile.tr(),
                  style: theme.primaryTextTheme.headline5,
                ),
                const SizedBox(
                  width: Dimens.size20,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCellCountFollow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.size10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                _user.follower?.length.toString() ?? '0',
                style: theme.primaryTextTheme.headline2,
              ),
              const SizedBox(height: Dimens.size8),
              Text(
                TranslationKey.follower.tr(),
                style: theme.primaryTextTheme.subtitle1,
              ),
            ],
          ),
          Container(
            height: Dimens.size40,
            color: theme.primaryColor,
            width: Dimens.size1,
          ),
          Column(
            children: [
              Text(
                _user.following?.length.toString() ?? '0',
                style: theme.primaryTextTheme.headline2,
              ),
              const SizedBox(height: Dimens.size8),
              Text(
                TranslationKey.following.tr(),
                style: theme.primaryTextTheme.subtitle1,
              ),
            ],
          ),
          Container(
            height: Dimens.size40,
            color: theme.primaryColor,
            width: Dimens.size1,
          ),
          Column(
            children: [
              Text(
                _user.posts?.length.toString() ?? '0',
                style: theme.primaryTextTheme.headline2,
              ),
              const SizedBox(height: Dimens.size8),
              Text(
                TranslationKey.posts.tr(),
                style: theme.primaryTextTheme.subtitle1,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBio(Size size, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.size20),
      child: SizedBox(
        width: size.width,
        child: Text(
          _user.bio ?? '',
          style: theme.primaryTextTheme.bodyText2,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildFullName(ThemeData theme) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.size20),
      child: SizedBox(
        width: size.width,
        child: Text(
          _user.fullName ?? Constants.fullNameDefault,
          style: theme.textTheme.headline5,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Text _buildUserName(ThemeData theme) {
    return Text(
      '@' + (_user.username ?? Constants.fullNameDefault),
      style: theme.primaryTextTheme.headline3,
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return GestureDetector(
      onTap: (){
        navService.push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) =>  FullImageScreen(
                image: [_user.imageUrl ?? '']),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(Dimens.size3),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: theme.primaryColor),
            borderRadius: BorderRadius.circular(28)),
        child: SizedBox(
          width: Dimens.size80,
          height: Dimens.size80,
          child: Hero(
            tag: _user.imageUrl ?? '',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: _user.imageUrl == ''
                  ? Image.asset(
                      MyImages.defaultAvt,
                      fit: BoxFit.cover,
                    )
                  : Image.network(_user.imageUrl ?? '',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
