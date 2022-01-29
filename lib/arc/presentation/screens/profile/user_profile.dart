import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/profile/profile_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/widget/loading_profile.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_button.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  const UserProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserData _user = UserData();
  bool _isFollowing = false;
  List<PostData> _listPhotos = [];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(InitProfileUserEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is InitProfileSuccessState) {
          _user = state.user;
          if ((_user.follower ?? []).contains(StaticVariable.myData?.userId)) {
            _isFollowing = true;
          }
          for (PostData post in state.user.posts ?? []) {
            if (post.images!.isNotEmpty) {
              _listPhotos.add(post);
            }
          }
        }
        if (state is OnFollowSuccessState) {
          EasyLoading.dismiss();
          _isFollowing = true;
        }
        if (state is OnUnFollowSuccessState) {
          EasyLoading.dismiss();
          _isFollowing = false;
        }
        if (state is LoadingClickedFollowState) {
          EasyLoading.show();
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is LoadingInitProfileState) {
            return const LoadingProfile();
          }
          final theme = Theme.of(context);
          final size = MediaQuery.of(context).size;
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(Dimens.size8),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.size12),
                        child: Image.asset(MyImages.icBack),
                      )),
                ),
              ),
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
                      _buildAvatar(theme),
                      const SizedBox(height: Dimens.size15),
                      _buildFullName(theme),
                      const SizedBox(height: Dimens.size8),
                      _buildBio(size, theme),
                      const SizedBox(height: Dimens.size16),
                      _isFollowing == true
                          ? followingWidget(theme)
                          : notFollowingWidget(theme),
                      const SizedBox(height: Dimens.size20),
                      _buildCellCountFollow(theme),
                      const SizedBox(height: Dimens.size15),
                      Padding(
                        padding: const EdgeInsets.all(Dimens.size15),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            crossAxisCount: 3
                          ),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                _listPhotos[index].images?.first ?? '',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          itemCount: _listPhotos.length,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row followingWidget(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            context
                .read<ProfileBloc>()
                .add(OnUnFollowClickedEvent(widget.userId));
          },
          child: SizedBox(
              width: Dimens.size40,
              height: Dimens.size40,
              child: Image.asset(MyImages.icSetting)),
        ),
        const SizedBox(
          width: Dimens.size15,
        ),
        Container(
          height: Dimens.size40,
          width: Dimens.size150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: theme.primaryColor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.size10),
                child: Image.asset(MyImages.icFlightSelected),
              ),
              Text(
                TranslationKey.message.tr(),
                style: theme.textTheme.headline2,
              ),
              const SizedBox(
                width: Dimens.size10,
              )
            ],
          ),
        )
      ],
    );
  }

  Row notFollowingWidget(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          onTap: () {
            context
                .read<ProfileBloc>()
                .add(OnFollowClickedEvent(widget.userId));
          },
          label: TranslationKey.follow.tr(),
          sizeWidth: Dimens.size120,
          sizeHeight: Dimens.size40,
        ),
        const SizedBox(width: Dimens.size15),
        Container(
          width: Dimens.size40,
          height: Dimens.size40,
          decoration: BoxDecoration(
              color: theme.primaryColorLight,
              border: Border.all(width: 1, color: theme.primaryColor),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.size10),
            child: Image.asset(MyImages.icFlightSelected),
          ),
        ),
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

  SizedBox _buildBio(Size size, ThemeData theme) {
    return SizedBox(
      width: size.width,
      child: Text(
        _user.bio ?? '',
        style: theme.primaryTextTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Text _buildFullName(ThemeData theme) {
    return Text(
      _user.fullName ?? '',
      style: theme.primaryTextTheme.headline2,
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(Dimens.size2),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: theme.primaryColor),
          borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: Dimens.size80,
        height: Dimens.size80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: _user.imageUrl == ''
              ? Image.asset(
                  MyImages.defaultAvt,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: _user.imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
