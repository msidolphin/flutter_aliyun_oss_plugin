import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_oss/aliyun_oss.dart';

void main() {
  const MethodChannel channel = MethodChannel('aliyun_oss');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AliyunOss.platformVersion, '42');
  });
}
