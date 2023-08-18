import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_detail.freezed.dart';
part 'product_detail.g.dart';

@freezed
class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required String productId,
    required String productName,
    required String homeShopName,
    required String broadcastDate,
    required String broadcastTime,
    required int priceLowest,
    required String lowestUrl,
    required String productImage,
    required String lowestShop,
  }) = _ProductDetail;

  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);
}


// {"productId":"64dde442a33b6f5f41fa7b8f","productName":"가이거골프 반팔니트","homeShopName":"롯데홈쇼핑","broadcastDate":"2023-08-17","broadcastTime":"10시 25분","priceLowest":84040,"lowestUrl":"https://smartstore.naver.com/sellzy/products/8991243022?NaPm=ct%3Dllezh57k%7Cci%3Dd34a1e6d34209ff43e94916654d8ac0f9e8361bb%7Ctr%3Dslsl%7Csn%3D7897254%7Chk%3D22a823b67a09df7c66bb9602278d17d138bc0689","productImage":"https://shop-phinf.pstatic.net/20230804_35/1691122812809OI84D_PNG/6048500927805049_1912873228.png?type=m510"}
