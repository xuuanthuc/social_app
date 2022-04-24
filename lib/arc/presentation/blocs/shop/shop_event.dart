part of 'shop_bloc.dart';
abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class LoadListItemEvent extends ShopEvent {}

class OnPickImageEvent extends ShopEvent{}

class OnDeleteImageEvent extends ShopEvent{
  final int index;
  const OnDeleteImageEvent(this.index);
}

class UploadNewSellItemEvent extends ShopEvent{
  final ShopItem item;
  const UploadNewSellItemEvent(this.item);
}

class InitProfileSellerEvent extends ShopEvent {
  final String userId;
  const InitProfileSellerEvent(this.userId);
}

class GetDetailItem extends ShopEvent {
  final String id;
  const GetDetailItem(this.id);
}

class UpdateSellItemEvent extends ShopEvent{
  final ShopItem item;
  final List<File>? listImageFile;
  const UpdateSellItemEvent(this.item, this.listImageFile);
}

class OnDeleteProduct extends ShopEvent {
  final String id;
  const OnDeleteProduct(this.id);
}