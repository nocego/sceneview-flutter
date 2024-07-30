import '../models/scene_node.dart';
import '../utils/channel_manager.dart';

class NodeManager {
  final ChannelManager _channelManager;

  NodeManager(this._channelManager);

  Future<void> addNode(SceneNode node) async {
    final nodeData = {
      'type': 'reference',
      'id': node.id,
      'position': {
        'x': node.position.x,
        'y': node.position.y,
        'z': node.position.z,
      },
      'rotation': {
        'x': node.rotation.x,
        'y': node.rotation.y,
        'z': node.rotation.z,
        'w': node.rotation.w,
      },
      'scale': {
        'x': node.scale.x,
        'y': node.scale.y,
        'z': node.scale.z,
      },
      'fileLocation': node.fileLocation,
    };
    await _channelManager.invokeMethod('addNode', nodeData);
  }

  Future<void> removeNode(String nodeId) async {
    print("Removing node: $nodeId");
    await _channelManager.invokeMethod('removeNode', {'nodeId': nodeId});
  }

  Future<void> updateNode(SceneNode node) async {
    print("Updating node: ${node.id}");
    await _channelManager.invokeMethod('updateNode', node.toJson());
  }
}
