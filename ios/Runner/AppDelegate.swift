import ARKit
import Flutter
import QuickLook
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ARQuickLookPlugin") {
      ARQuickLookPlugin.register(with: registrar)
    }
  }
}

/// Abre un USDZ incluido en los assets de Flutter con AR Quick Look.
final class ARQuickLookPlugin: NSObject, FlutterPlugin, QLPreviewControllerDataSource {
  private let registrar: FlutterPluginRegistrar
  private var fileURL: URL?

  init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
  }

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "huapalcalco/ar", binaryMessenger: registrar.messenger())
    let instance = ARQuickLookPlugin(registrar: registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "openQuickLook" else {
      result(FlutterMethodNotImplemented)
      return
    }
    guard
      let args = call.arguments as? [String: Any],
      let asset = args["asset"] as? String,
      let path = Bundle.main.path(forResource: registrar.lookupKey(forAsset: asset), ofType: nil)
    else {
      result(FlutterError(code: "missing_asset", message: "No se encontró el modelo de AR.", details: nil))
      return
    }
    fileURL = URL(fileURLWithPath: path)
    guard let presenter = Self.topViewController() else {
      result(FlutterError(code: "no_presenter", message: "No hay una pantalla activa.", details: nil))
      return
    }
    let preview = QLPreviewController()
    preview.dataSource = self
    presenter.present(preview, animated: true)
    result(nil)
  }

  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    return fileURL == nil ? 0 : 1
  }

  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    let item = ARQuickLookPreviewItem(fileAt: fileURL!)
    item.allowsContentScaling = true
    return item
  }

  private static func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let window = scenes.flatMap { $0.windows }.first { $0.isKeyWindow }
    var top = window?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
}
