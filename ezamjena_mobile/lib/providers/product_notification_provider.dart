import 'package:ezamjena_mobile/providers/base_provider.dart';
import '../model/product_notification.dart';

class ProductNotificationProvider extends BaseProvider<ProductNotification> {
  ProductNotificationProvider() : super("NotifikacijaProizvod");

  @override
  ProductNotification fromJson(data) => ProductNotification.fromJson(data);
}
