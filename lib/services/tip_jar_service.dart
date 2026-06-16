import 'package:in_app_purchase/in_app_purchase.dart';

/// Tip jar SKU — configure matching product in App Store Connect / Play Console.
const tipJarProductId = 'veld_tip_jar';

class TipJarService {
  TipJarService();

  final InAppPurchase _iap = InAppPurchase.instance;

  Future<bool> get isAvailable => _iap.isAvailable();

  Future<ProductDetails?> fetchProduct() async {
    final response = await _iap.queryProductDetails({tipJarProductId});
    if (response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  Future<bool> purchase(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restore() => _iap.restorePurchases();

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;
}
