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
import io.github.sceneview.sceneview_flutter.handlers.GestureHandler
import io.github.sceneview.sceneview_flutter.handlers.MethodCallHandler
import io.github.sceneview.sceneview_flutter.handlers.EventHandler
import io.github.sceneview.sceneview_flutter.models.SceneViewAugmentedImage
import io.github.sceneview.sceneview_flutter.utils.Constants
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel

class SceneViewWrapper(
    private val context: Context,
    private val activity: Activity,
    private val lifecycle: Lifecycle,
    messenger: BinaryMessenger,
    id: Int,
    private val arConfig: ARSceneViewConfig,
    private val augmentedImages: List<SceneViewAugmentedImage>
) : PlatformView {

    private var sceneView: ARSceneView? = null
    private var gestureHandler: GestureHandler
    private val methodCallHandler: MethodCallHandler
    private val eventHandler: EventHandler
    private val mainScope = CoroutineScope(Dispatchers.Main)

    init {
        sceneView = ARSceneView(
            context,
            sharedLifecycle = lifecycle,
            sessionConfiguration = ARSceneViewConfig.createSessionConfigurationCallback(arConfig, augmentedImages)
        )
        eventHandler = EventHandler(id, messenger)
        gestureHandler = GestureHandler(sceneView, eventHandler)
        methodCallHandler = MethodCallHandler(sceneView, activity, id, messenger, mainScope)
        initializeARSceneView()
    }

    private fun initializeARSceneView() {
        sceneView?.apply {
            setupSessionCallbacks()
            ARSceneViewConfig.configureSceneView(this, arConfig, augmentedImages)
            setOnTouchListener(gestureHandler)

        }
    }

    private fun ARSceneView.setupSessionCallbacks() {

        onSessionUpdated = { session, frame ->
            // Handle session updates
            Log.d("SceneViewWrapper", "Session updated")
            eventHandler.sendSessionUpdateEvent(session, frame)

            // Add this new code for augmented image detection
            frame.getUpdatedAugmentedImages().forEach { augmentedImage ->
                Log.d("SceneViewWrapper", "Augmented image detected: ${augmentedImage.name}")
                eventHandler.sendEvent(Constants.EVENT_AUGMENTED_IMAGE_DETECTED, augmentedImage.name)

                // Here you can add logic to create and add nodes for detected images
                // This depends on what you want to do when an image is detected
                // For example:
                // addAugmentedImageNode(augmentedImage)
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