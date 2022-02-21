import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/upload/upload_bloc.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/utilities/showtoast.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class AddStoryScreen extends StatefulWidget {
  final File imageFile;

  const AddStoryScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _AddStoryScreenState createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  void addStory() {
    context.read<UploadBloc>().add(OnSubmitUploadStory());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if(state is UploadStorySuccessState){
          EasyLoading.dismiss();
          Navigator.of(context).pop();
        }
        if(state is LoadingSharePostState){
          EasyLoading.show();
        }
        if(state is SharePostFailedState){
          EasyLoading.dismiss();
          ToastView.show(state.error);
        }
      },
      child: BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.black,
            body: Column(
              children: [
                const Spacer(),
                Center(
                  child: Image.file(widget.imageFile),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: addStory,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: Dimens.size8,
                      ),
                      Text(
                        TranslationKey.addStory.tr(),
                        style: theme.primaryTextTheme.button,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: Dimens.size30),
              ],
            ),
          );
        },
      ),
    );
  }
}
