package com.pratikbilisim.kiosk

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

// CSN SDK imports (provided by CSNPrinterSDK.jar in app/libs)
import com.csnprintersdk.csnio.CSNPOS
import com.csnprintersdk.csnio.CSNBTPrinting
import com.csnprintersdk.csnio.csnbase.CSNIOCallBack

/**
 * Kotlin bridge to CSN printer SDK.
 *
 * Notes:
 * - Place `CSNPrinterSDK.jar` into `android/app/libs` (or `app/libs`) and make sure Gradle includes it (see README).
 * - This class exposes simple methods via a MethodChannel:
 *   - initPrinter()
 *   - connectBT(address)
 *   - disconnect()
 *   - printText(text)
 *
 * The implementation mirrors the sample/demo app included in the SDK package.
 */
class PrinterHandler(private val context: Context) : MethodCallHandler {

    private val mainHandler = Handler(Looper.getMainLooper())

    // CSN objects (lazy-initialized)
    private val bt: CSNBTPrinting by lazy { CSNBTPrinting() }
    private val pos: CSNPOS by lazy { CSNPOS().apply { Set(bt) } }

    // simple callback adapter so we can forward connection events if needed
    private val ioCallback: CSNIOCallBack = object : CSNIOCallBack {
        override fun OnOpen() {}
        override fun OnOpenFailed() {}
        override fun OnClose() {}
    }

    init {
        try {
            bt.SetCallBack(ioCallback)
        } catch (e: Throwable) {
            // SDK not available or callback failed; we'll handle at call time
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initPrinter" -> {
                // Just ensure classes are loadable and objects created
                try {
                    // Accessing pos and bt forces classloading
                    val opened = pos.GetIO()?.IsOpened() ?: false
                    result.success(mapOf("ok" to true, "isOpened" to opened))
                } catch (e: Throwable) {
                    result.error("INIT_ERROR", "CSN SDK not found or failed to init: ${e.message}", null)
                }
            }
            "connectBT" -> {
                val address = call.argument<String>("address") ?: ""
                if (address.isBlank()) {
                    result.error("ARG_ERROR", "address argument is required", null)
                    return
                }

                // open on background thread
                Thread {
                    try {
                        val ok = bt.Open(address, context)
                        mainHandler.post { result.success(mapOf("ok" to ok)) }
                    } catch (e: Throwable) {
                        mainHandler.post { result.error("CONNECT_ERROR", e.message, null) }
                    }
                }.start()
            }
            "disconnect" -> {
                try {
                    bt.Close()
                    result.success(true)
                } catch (e: Throwable) {
                    result.error("DISCONNECT_ERROR", e.message, null)
                }
            }
            "printText" -> {
                val text = call.argument<String>("text") ?: ""
                try {
                    // Ensure connection
                    val isOpened = pos.GetIO()?.IsOpened() ?: false
                    if (!isOpened) {
                        result.error("NOT_CONNECTED", "Printer is not opened", null)
                        return
                    }

                    // Use the demo's POS_TextOut call; parameters chosen for a simple print
                    // (mode, size, etc.) Adjust as required.
                    val r = pos.POS_TextOut(text + "\r\n", 0, 0, 0, 0, 0, 0)
                    result.success(mapOf("resultCode" to r))
                } catch (e: Throwable) {
                    result.error("PRINT_ERROR", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }
}
