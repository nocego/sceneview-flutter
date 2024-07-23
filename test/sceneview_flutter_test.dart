import 'package:flutter_test/flutter_test.dart';
import 'package:sceneview_flutter/sceneview_flutter.dart';
import 'package:sceneview_flutter/sceneview_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSceneviewFlutterPlatform
    with MockPlatformInterfaceMixin
    implements SceneviewFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SceneviewFlutterPlatform initialPlatform = SceneviewFlutterPlatform.instance;

  test('$MethodChannelSceneviewFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSceneviewFlutter>());
  });

  test('getPlatformVersion', () async {
    SceneviewFlutter sceneviewFlutterPlugin = SceneviewFlutter();
    MockSceneviewFlutterPlatform fakePlatform = MockSceneviewFlutterPlatform();
    SceneviewFlutterPlatform.instance = fakePlatform;

    expect(await sceneviewFlutterPlugin.getPlatformVersion(), '42');
  });
}
