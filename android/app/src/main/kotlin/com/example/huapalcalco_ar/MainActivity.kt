package com.example.huapalcalco_ar

import android.content.Intent
import com.google.ar.core.ArCoreApk
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "huapalcalco/ar")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAr" -> openAr(result)
                    else -> result.notImplemented()
                }
            }
    }

    /** Abre la maqueta en AR si el equipo es compatible con ARCore. */
    private fun openAr(result: MethodChannel.Result) {
        ArCoreApk.getInstance().checkAvailabilityAsync(this) { availability ->
            if (availability == ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE) {
                result.error(
                    "unsupported",
                    "Este equipo no es compatible con la realidad aumentada de Google.",
                    null,
                )
            } else {
                // Si falta instalar o actualizar Google Play Services para AR,
                // ArActivity lo solicita al crear la sesión.
                startActivity(Intent(this, ArActivity::class.java))
                result.success(null)
            }
        }
    }
}
