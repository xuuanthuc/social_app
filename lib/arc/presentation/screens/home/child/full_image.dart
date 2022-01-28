import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullImageScreen extends StatefulWidget {
  final List<String> image;
  final VoidCallback comment;
  final String countCmt;
  String countLike;
  PostData post;

  FullImageScreen(
      {Key? key,
      required this.image,
      required this.countLike,
      required this.comment,
      required this.post,
      required this.countCmt})
      : super(key: key);

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  PageController _controller = PageController();
  bool _liked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      widget.post.likes!.contains(StaticVariable.myData?.userId)
          ? _liked = true
          : _liked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is OnDisLikedPostState) {
          _liked = false;
          widget.countLike = state.post.likes?.length.toString() ?? '';
        }
        if (state is OnLikedPostState) {
          _liked = true;
          widget.countLike = state.post.likes?.length.toString() ?? '';
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Stack(
              children: [
                Center(
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(widget.image[index]),
                        initialScale: PhotoViewComputedScale.contained,
                      );
                    },
                    itemCount: widget.image.length,
                    loadingBuilder: (context, event) => const Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    pageController: _controller,
                  ),
                ),
                Positioned(
                  bottom: Dimens.size20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimens.size5),
                      Row(
                        children: [
                          const SizedBox(width: Dimens.size10),
                          GestureDetector(
                            onTap: _liked == true
                                ? () {
                                    context
                                        .read<HomeBloc>()
                                        .add(OnDisLikePostEvent(widget.post));
                                  }
                                : () {
                                    context
                                        .read<HomeBloc>()
                                        .add(OnLikePostEvent(widget.post));
                                  },
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(Dimens.size10),
                                child: SvgPicture.asset(
                                  _liked == true
                                      ? MyImages.icLiked
                                      : MyImages.icUnLiked,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _liked == true
                                ? () {
                                    context
                                        .read<HomeBloc>()
                                        .add(OnDisLikePostEvent(widget.post));
                                  }
                                : () {
                                    context
                                        .read<HomeBloc>()
                                        .add(OnLikePostEvent(widget.post));
                                  },
                            child: Text(
                              widget.countLike,
                              style: theme.primaryTextTheme.button,
                            ),
                          ),
                          const SizedBox(width: Dimens.size20),
                          GestureDetector(
                            onTap: widget.comment,
                            child: Padding(
                              padding: const EdgeInsets.all(Dimens.size5),
                              child: SvgPicture.asset(
                                MyImages.icComment,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimens.size5),
                          GestureDetector(
                            onTap: widget.comment,
                            child: Text(
                              widget.countCmt,
                              style: theme.primaryTextTheme.button,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimens.size5),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
