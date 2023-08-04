import 'dart:convert';
import '../model/trade.dart';
import 'base_provider.dart';

class ExchangeProvider extends BaseProvider<Trade> {
  ExchangeProvider() : super("Razmjena");

  @override
  Trade fromJson(data) {
    return Trade.fromJson(data);
  }
}
