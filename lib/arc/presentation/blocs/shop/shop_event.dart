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