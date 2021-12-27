import Flutter
import UIKit

public class SwiftFlutterFortuneWheelPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_fortune_wheel", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterFortuneWheelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
