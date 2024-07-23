import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/depth_mode.dart';
import '../enums/instant_placement_mode.dart';
import '../enums/light_estimation_mode.dart';

part 'ar_scene_config.freezed.dart';
part 'ar_scene_config.g.dart';

@freezed
class ARSceneConfig with _$ARSceneConfig {
  const factory ARSceneConfig({
    @Default(true) bool planeFindingEnabled,
    @Default(true) bool planeRendererEnabled,
    @Default(true) bool depthEnabled,
    @Default(true) bool instantPlacementEnabled,
    @Default(true) bool augmentedImageDatabaseEnabled,
    @Default(true) bool augmentedFaceEnabled,
    @Default(LightEstimationMode.environmentalHDR)
    LightEstimationMode lightEstimationMode,
    @Default(DepthMode.automatic) DepthMode depthMode,
    @Default(InstantPlacementMode.localYUp)
    InstantPlacementMode instantPlacementMode,
    @Default(false) bool cloudAnchorEnabled,
    @Default(false) bool geospatialEnabled,
  }) = _ARSceneConfig;

  factory ARSceneConfig.fromJson(Map<String, dynamic> json) =>
      _$ARSceneConfigFromJson(json);

  const ARSceneConfig._();

  @override
  Map<String, dynamic> toJson() => {
        'planeFindingEnabled': planeFindingEnabled,
        'planeRendererEnabled': planeRendererEnabled,
        'depthEnabled': depthEnabled,
        'instantPlacementEnabled': instantPlacementEnabled,
        'augmentedImageDatabaseEnabled': augmentedImageDatabaseEnabled,
        'augmentedFaceEnabled': augmentedFaceEnabled,
        'lightEstimationMode':
            lightEstimationMode.toString().split('.').last.toUpperCase(),
        'depthMode': depthMode.toString().split('.').last.toUpperCase(),
        'instantPlacementMode':
            instantPlacementMode.toString().split('.').last.toUpperCase(),
        'cloudAnchorEnabled': cloudAnchorEnabled,
        'geospatialEnabled': geospatialEnabled,
        'planeRenderer': {
          'isEnabled': planeRendererEnabled,
          'isVisible': planeRendererEnabled,
        },
      };
}
