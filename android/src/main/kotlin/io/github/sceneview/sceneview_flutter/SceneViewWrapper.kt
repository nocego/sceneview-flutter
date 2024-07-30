package io.github.sceneview.sceneview_flutter.core

import android.content.Context
import android.app.Activity
import android.util.Log
import android.view.View
import androidx.lifecycle.Lifecycle
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.github.sceneview.ar.ARSceneView
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
    private lateinit var gestureHandler: GestureHandler
    private val methodCallHandler: MethodCallHandler
    private val eventHandler: EventHandler
    private val mainScope = CoroutineScope(Dispatchers.Main)

    init {
        sceneView = ARSceneView(context, sharedLifecycle = lifecycle)
        eventHandler = EventHandler(id, messenger)
        gestureHandler = GestureHandler(sceneView, mainScope, eventHandler)
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