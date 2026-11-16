package com.example.huapalcalco_ar

import android.os.Bundle
import android.view.MotionEvent
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.google.ar.core.Anchor
import com.google.ar.core.Config
import com.google.ar.core.Frame
import com.google.ar.core.Plane
import com.google.ar.core.TrackingState
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.ar.arcore.getUpdatedPlanes
import io.github.sceneview.rememberEngine
import io.github.sceneview.rememberModelInstance
import io.github.sceneview.rememberModelLoader

/** Colores de la línea gráfica (lib/theme/hp_theme.dart). */
private val Ink = Color(0xFF0B1210)
private val Brote = Color(0xFF9BE36D)
private val Stone = Color(0xFF5E6A65)

/**
 * Maqueta de Huapalcalco en realidad aumentada, a escala 1:50.
 *
 * El modelo (assets/models/huapalcalco_ar.glb) se genera con
 * tool/blender/prepare_model.py. Mide 33 cm de frente y su origen está al
 * centro de la base, así que se apoya directo sobre la superficie.
 */
class ArActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        setContent { ArScreen(onClose = ::finish) }
    }
}

/** Contenedor sin estado de Compose para el cuadro más reciente de ARCore. */
private class FrameHolder {
    var frame: Frame? = null
}

@Composable
private fun ArScreen(onClose: () -> Unit) {
    val engine = rememberEngine()
    val modelLoader = rememberModelLoader(engine)
    val model = rememberModelInstance(modelLoader, "models/huapalcalco_ar.glb")
    val latest = remember { FrameHolder() }
    var anchor by remember { mutableStateOf<Anchor?>(null) }
    var surfaceFound by remember { mutableStateOf(false) }
    var failed by remember { mutableStateOf(false) }

    Box(Modifier.fillMaxSize()) {
        ARSceneView(
            modifier = Modifier.fillMaxSize(),
            engine = engine,
            modelLoader = modelLoader,
            planeFindingMode = Config.PlaneFindingMode.HORIZONTAL,
            planeRenderer = anchor == null,
            onSessionFailed = { failed = true },
            onSessionUpdated = { _, frame ->
                latest.frame = frame
                if (!surfaceFound) {
                    surfaceFound = frame.getUpdatedPlanes().any {
                        it.type == Plane.Type.HORIZONTAL_UPWARD_FACING &&
                            it.trackingState == TrackingState.TRACKING
                    }
                }
            },
            onTouchEvent = { event, _ ->
                if (anchor == null && event.action == MotionEvent.ACTION_UP) {
                    val hit = latest.frame?.hitTest(event.x, event.y)?.firstOrNull {
                        val plane = it.trackable as? Plane
                        plane != null &&
                            plane.type == Plane.Type.HORIZONTAL_UPWARD_FACING &&
                            plane.isPoseInPolygon(it.hitPose)
                    }
                    if (hit != null) {
                        anchor = hit.createAnchor()
                        true
                    } else {
                        false
                    }
                } else {
                    false
                }
            },
        ) {
            anchor?.let { a ->
                AnchorNode(anchor = a) {
                    model?.let { ModelNode(modelInstance = it, isEditable = true) }
                }
            }
        }

        Box(
            Modifier
                .safeDrawingPadding()
                .padding(16.dp)
                .size(44.dp)
                .clip(CircleShape)
                .background(Color.White.copy(alpha = 0.9f))
                .clickable(onClick = onClose)
                .semantics { contentDescription = "Cerrar" },
            contentAlignment = Alignment.Center,
        ) {
            BasicText("✕", style = TextStyle(fontSize = 18.sp, color = Ink, fontWeight = FontWeight.SemiBold))
        }

        val (title, complement, hint) = when {
            failed -> Triple("No se pudo", "iniciar la cámara", "Revisa el permiso de cámara y que Google Play Services para AR esté actualizado.")
            model == null -> Triple("Cargando", "la maqueta", "Un momento.")
            anchor != null -> Triple("Maqueta", "a escala 1:50", "Pellizca para cambiar el tamaño y gira con dos dedos.")
            surfaceFound -> Triple("Fija la maqueta", "en una mesa", "Toca la superficie marcada.")
            else -> Triple("Busca una mesa", "o el piso", "Mueve el teléfono despacio para reconocer la superficie.")
        }
        Row(
            Modifier
                .align(Alignment.BottomCenter)
                .safeDrawingPadding()
                .padding(12.dp)
                .fillMaxWidth()
                .clip(RoundedCornerShape(30.dp))
                .background(Color.White)
                .padding(horizontal = 20.dp, vertical = 18.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            Column(Modifier.weight(1f)) {
                BasicText(title, style = TextStyle(fontSize = 22.sp, fontWeight = FontWeight.ExtraBold, color = Ink))
                BasicText(complement, style = TextStyle(fontSize = 17.sp, color = Ink))
                BasicText(hint, modifier = Modifier.padding(top = 6.dp), style = TextStyle(fontSize = 13.sp, color = Stone))
            }
            if (anchor != null) {
                Box(
                    Modifier
                        .clip(RoundedCornerShape(99.dp))
                        .background(Brote)
                        .clickable {
                            anchor?.detach()
                            anchor = null
                        }
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                ) {
                    BasicText("Reubicar", style = TextStyle(fontSize = 15.sp, fontWeight = FontWeight.Bold, color = Ink))
                }
            }
        }
    }
}
