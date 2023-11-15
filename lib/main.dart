import 'package:flutter/material.dart';
import 'package:speculation_exchange/speculation_exchange.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  //???
  //https://docs.flutter.dev/ui/navigation/url-strategies
  usePathUrlStrategy();
  runApp(const SpeculationExchange());
}