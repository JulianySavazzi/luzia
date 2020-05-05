package com.luziadevelopers.luzia;

import io.flutter.app.FlutterApplication;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

public class Application extends FlutterApplication implements PluginRegistrantCallback {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine); //alteração do agora.sdk
    }

    @Override
    public void onCreate() {
        super.onCreate();
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
    }
}
