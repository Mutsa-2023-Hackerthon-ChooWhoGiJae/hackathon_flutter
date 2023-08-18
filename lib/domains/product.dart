import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String productId,
    required String homeShopName,
    required String broadcastTime,
    required String productName,
    required String productImage,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
// {"productId":"64dde442a33b6f5f41fa7b7e","homeShopName":"롯데홈쇼핑","broadcastTime":"1시 00분","productName":"에이스바이옴 비에날 퀸","productImage":"https://image.auction.co.kr/itemimage/31/61/95/3161950916.jpg"}