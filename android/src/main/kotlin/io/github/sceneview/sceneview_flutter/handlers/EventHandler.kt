package io.github.sceneview.sceneview_flutter.handlers

import com.google.ar.core.Frame
import com.google.ar.core.Session
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.github.sceneview.sceneview_flutter.utils.Constants

class EventHandler(
    id: Int,
    messenger: BinaryMessenger
) : EventChannel.StreamHandler {

    private val eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    init {
        val eventChannelName = "${Constants.CHANNEL_NAME_PREFIX}/events_$id"
        eventChannel = EventChannel(messenger, eventChannelName)
        eventChannel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun sendEvent(eventName: String, data: Any?) {
        eventSink?.success(mapOf("event" to eventName, "data" to data))
    }

    fun sendSessionUpdateEvent(session: Session, frame: Frame) {
        // Implement session update event logic here
    }

    fun dispose() {
        eventChannel.setStreamHandler(null)
        eventSink = null
    }
}