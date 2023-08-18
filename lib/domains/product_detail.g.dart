// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProductDetail _$$_ProductDetailFromJson(Map<String, dynamic> json) =>
    _$_ProductDetail(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      homeShopName: json['homeShopName'] as String,
      broadcastDate: json['broadcastDate'] as String,
      broadcastTime: json['broadcastTime'] as String,
      priceLowest: json['priceLowest'] as int,
      lowestUrl: json['lowestUrl'] as String,
      productImage: json['productImage'] as String,
      lowestShop: json['lowestShop'] as String,
    );

Map<String, dynamic> _$$_ProductDetailToJson(_$_ProductDetail instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'homeShopName': instance.homeShopName,
      'broadcastDate': instance.broadcastDate,
      'broadcastTime': instance.broadcastTime,
      'priceLowest': instance.priceLowest,
      'lowestUrl': instance.lowestUrl,
      'productImage': instance.productImage,
      'lowestShop': instance.lowestShop,
    };
