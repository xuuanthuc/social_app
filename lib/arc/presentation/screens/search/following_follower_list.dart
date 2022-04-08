import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/search/widget/loading_list_user.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

import '../../../../src/styles/dimens.dart';
import '../../../../src/styles/images.dart';
import '../../../data/models/data_models/user.dart';
import '../../blocs/search/search_bloc.dart';
import '../profile/user_profile.dart';

class ListFollowUserScreen extends StatefulWidget {
  final List<String> listUserId;

  const ListFollowUserScreen({Key? key, required this.listUserId})
      : super(key: key);

  @override
  State<ListFollowUserScreen> createState() => _ListFollowUserScreenState();
}

class _ListFollowUserScreenState extends State<ListFollowUserScreen> {
  List<UserData> _listUser = [];

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<SearchBloc>().add(LoadListUserEvent(widget.listUserId));
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc()..add(LoadListUserEvent(widget.listUserId)),
      child: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is LoadListUserSuccessState) {
            _listUser = state.listUser ?? [];
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is LoadingListState) {
              return const LoadingListUserScreen();
            }
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
              body: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildItemUser(context, index, theme);
                },
                itemCount: _listUser.length,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemUser(BuildContext context, int index, ThemeData theme) {
    return InkWell(
      onTap: () async {
        if (_listUser[index].userId == StaticVariable.myData?.userId) return;
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
