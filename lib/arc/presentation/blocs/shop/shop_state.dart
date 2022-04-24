part of 'shop_bloc.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

class InitState extends ShopState {}

class LoadingShopState extends ShopState {}

class LoadingUploadNewItemState extends ShopState {}

class LoadListItemSuccessState extends ShopState {
  final List<ShopItem>? listItem;

  const LoadListItemSuccessState(this.listItem);
}

class ImagePickedState extends ShopState {
  final List<File>? listImageFiles;

  const ImagePickedState({this.listImageFiles});
}

class OnDeleteImageState extends ShopState {
  final List<File>? listImageFiles;

  const OnDeleteImageState({this.listImageFiles});
}

class UploadNewSellItemSuccessState extends ShopState {}

class UpdateNewSellItemSuccessState extends ShopState {}

class InitProfileSuccessState extends ShopState {
  final UserData user;

  const InitProfileSuccessState(this.user);
}

class GetDetailItemSuccessState extends ShopState{
  final ShopItem item;
  const GetDetailItemSuccessState(this.item);
}

class OnDeleteProductSuccessState extends ShopState{}