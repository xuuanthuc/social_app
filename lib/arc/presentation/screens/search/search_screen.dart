import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/search/search_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:provider/src/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<UserData> _listUser = [];

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
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: const AppBarDesign(),
            body: Column(
              children: [
                Container(
                  height: 50,
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      context
                          .read<SearchBloc>()
                          .add(OnSearchEvent(_controller.text));
                    },
                    child: Container(
                      height: 50,
                      child: Text('search'),
                    )),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: (){
                            context.read<SearchBloc>().add(OnFollowClickedEvent(_listUser[index].userId ?? ''));
                          },
                          child: Text(_listUser[index].fullName ?? ''));
                    },
                    itemCount: _listUser.length,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
