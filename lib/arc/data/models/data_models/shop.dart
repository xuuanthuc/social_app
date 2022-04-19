import 'dart:io';

class ShopItem {
  String? shopKeeperId;
  String? itemId;
  String? itemLabel;
  String? itemDescription;
  int? price;
  List<String>? images;
  List<File>? fileImages;
  int? itemType;
  int? quantity;
  String? address;
  String? contact;
  String? createdAt;

  ShopItem(
      {this.shopKeeperId,
      this.itemLabel,
        this.itemId,
      this.itemDescription,
      this.price,
      this.images,
      this.itemType,
      this.quantity,
      this.fileImages,
      this.address,
      this.createdAt,
      this.contact});

  ShopItem.fromJson(Map<String, dynamic> json) {
    var _listImage = <String>[];
    if(json['images'] != null){
      for(String image in json['images']){
        _listImage.add(image);
      }
    }
    shopKeeperId = json['shop_keeper_id'];
    itemLabel = json['item_label'];
    itemDescription = json['item_description'];
    price = json['price'];
    images = _listImage;
    itemId = json['id'];
    itemType = json['item_type'];
    quantity = json['quantity'];
    address = json['address'];
    contact = json['contact'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shop_keeper_id'] = shopKeeperId;
    data['item_label'] = itemLabel;
    data['item_description'] = itemDescription;
    data['price'] = price;
    data['images'] = images;
    data['item_type'] = itemType;
    data['quantity'] = quantity;
    data['address'] = address;
    data['contact'] = contact;
    data['created_at'] = createdAt;
    data['id'] = itemId;
    return data;
  }
}

class CategoryShop {
  String label;
  int value;

  CategoryShop({
    this.value = -1,
    this.label = 'Select Category',
  });
}
