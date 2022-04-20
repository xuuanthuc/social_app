import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/search/search_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/user_profile.dart';
import 'package:hii_xuu_social/arc/presentation/screens/search/widget/loading_search.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();
  List<UserData> _listUser = [];

  void search() {
    _focus.unfocus();
    context.read<SearchBloc>().add(OnSearchEvent(_controller.text));
  }

  @override
  void dispose() {
    super.dispose();
    _focus.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchSuccessState) {
          _listUser = state.listUser ?? [];
        }
      },
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is LoadingSearchState) {
            return LoadingSearchScreen(controller: _controller);
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
                      hasAction2: false,
                      centerTitle: true,
                      title: Text('Search', style: theme.textTheme.headline2,),
                      imgAction1: MyImages.icCameraSelected,
                      imgAction2: MyImages.icSend,
                      onTapAction1: () {
                        context.read<MainBloc>().add(OnChangePageEvent(Constants.page.camera));
                      },
                      onTapAction2: () {
                        context.read<MainBloc>().add(OnChangePageEvent(Constants.page.store));
                      },
                    ),
                    body: Column(
                      children: [
                        const SizedBox(height: Dimens.size8),
                        _buildSearchField(theme),
                        const SizedBox(height: Dimens.size20),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _buildItemUser(context, index, theme);
                            },
                            itemCount: _listUser.length,
                          ),
                        )
                      ],
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

  GestureDetector _buildItemUser(
      BuildContext context, int index, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return UserProfile(userId: _listUser[index].userId ?? '');
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.size15, vertical: Dimens.size10),
        child: Row(
          children: [
            _buildAvatarWidget(theme, _listUser[index].imageUrl ?? ''),
            const SizedBox(
              width: Dimens.size10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _listUser[index].fullName ?? '',
                  style: theme.primaryTextTheme.headline4,
                ),
                const SizedBox(height: Dimens.size5),
                Text(
                  '@' + (_listUser[index].username ?? ''),
                  style: theme.primaryTextTheme.subtitle1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildSearchField(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.size15),
      height: 40,
      child: TextField(
        focusNode: _focus,
        style: theme.textTheme.headline6,
        controller: _controller,
        cursorHeight: Dimens.size18,
        onEditingComplete: search,
        decoration: InputDecoration(
            hintText: '@username or full name',
            hintStyle: theme.primaryTextTheme.subtitle1,
            prefixIcon: GestureDetector(
              onTap: search,
              child: const Icon(Icons.search),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                _controller.clear();
              },
              child: const Icon(Icons.close),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: Dimens.size20, vertical: Dimens.size4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.shadowColor.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildAvatarWidget(ThemeData theme, String imageUrl) {
    return SizedBox(
      height: Dimens.size50,
      width: Dimens.size50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: imageUrl == ''
            ? Image.asset(
                MyImages.defaultAvt,
                fit: BoxFit.cover,
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
