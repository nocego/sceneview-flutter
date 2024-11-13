package io.github.sceneview.sceneview_flutter.core

import android.content.Context
import android.app.Activity
import android.util.Log
import android.view.View
import androidx.lifecycle.Lifecycle
import com.google.ar.core.Config
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.ar.arcore.addAugmentedImage
import io.github.sceneview.ar.arcore.getUpdatedAugmentedImages
import io.github.sceneview.sceneview_flutter.handlers.AugmentedImageHandler
import io.github.sceneview.sceneview_flutter.handlers.GestureHandler
import io.github.sceneview.sceneview_flutter.handlers.MethodCallHandler
import io.github.sceneview.sceneview_flutter.handlers.EventHandler
import io.github.sceneview.sceneview_flutter.handlers.NodeHandler
import io.github.sceneview.sceneview_flutter.models.SceneViewAugmentedImage
import io.github.sceneview.sceneview_flutter.utils.Constants
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class SceneViewWrapper(
    private val context: Context,
    private val activity: Activity,
    private val lifecycle: Lifecycle,
    messenger: BinaryMessenger,
    id: Int,
    private val arConfig: ARSceneViewConfig,
    private val augmentedImages: List<SceneViewAugmentedImage>,
    private val augmentedImageModels: Map<String, String>
) : PlatformView {

    private var sceneView: ARSceneView? = null
    private var gestureHandler: GestureHandler
    private val methodCallHandler: MethodCallHandler
    private val eventHandler: EventHandler
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private lateinit var augmentedImageHandler: AugmentedImageHandler
    private lateinit var nodeHandler: NodeHandler

    init {
        sceneView = ARSceneView(
            context,
            sharedLifecycle = lifecycle,
            sessionConfiguration = ARSceneViewConfig.createSessionConfigurationCallback(arConfig, augmentedImages)
        )
        eventHandler = EventHandler(id, messenger)
        gestureHandler = GestureHandler(sceneView, eventHandler)
        nodeHandler = NodeHandler(sceneView!!, activity)
        methodCallHandler = MethodCallHandler(sceneView, activity, id, messenger, mainScope)
        augmentedImageHandler = AugmentedImageHandler(
            context,
            sceneView!!,
            eventHandler,
            nodeHandler,
            mainScope,
            augmentedImageModels
        )
        initializeARSceneView()
        initializeAugmentedImages()
    }

    private fun initializeARSceneView() {
        sceneView?.apply {
            setupSessionCallbacks()
            ARSceneViewConfig.configureSceneView(this, arConfig, augmentedImages)
            setOnTouchListener(gestureHandler)

        }
    }

    private fun initializeAugmentedImages() {
        augmentedImages.forEach { image ->
            augmentedImageHandler.addAugmentedImageToTrack(image.name)
        }
    }

    private fun ARSceneView.setupSessionCallbacks() {

        onSessionUpdated = { session, frame ->
            // Handle session updates
            eventHandler.sendSessionUpdateEvent(session, frame)

            // Augmented image detection
            mainScope.launch {
                augmentedImageHandler.handleUpdatedAugmentedImages(frame.getUpdatedAugmentedImages())
            }
        }

        onSessionCreated = {
            Log.d("SceneViewWrapper", "Session created")
            eventHandler.sendEvent(Constants.EVENT_SESSION_CREATED, null)
        }

        onSessionResumed = {
            Log.d("SceneViewWrapper", "Session resumed")
            eventHandler.sendEvent(Constants.EVENT_SESSION_RESUMED, null)
        }

        onSessionPaused = {
            Log.d("SceneViewWrapper", "Session paused")
            eventHandler.sendEvent(Constants.EVENT_SESSION_PAUSED, null)
        }

        onSessionFailed = { exception ->
            Log.e("SceneViewWrapper", "Session failed", exception)
            eventHandler.sendEvent(Constants.EVENT_SESSION_FAILED, exception.message)
        }

        onTrackingFailureChanged = { reason ->
            Log.d("SceneViewWrapper", "Tracking failure changed: $reason")
            eventHandler.sendEvent(Constants.EVENT_TRACKING_FAILURE_CHANGED, reason?.ordinal)
        }
    }

    override fun getView(): View {
        return sceneView ?: throw IllegalStateException("SceneView not initialized")
    }

    override fun dispose() {
        sceneView?.destroy()
        methodCallHandler.dispose()
        eventHandler.dispose()
        mainScope.cancel()
    }
}