#import "FlutterFortuneWheelPlugin.h"
#if __has_include(<flutter_fortune_wheel/flutter_fortune_wheel-Swift.h>)
#import <flutter_fortune_wheel/flutter_fortune_wheel-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_fortune_wheel-Swift.h"
#endif

@implementation FlutterFortuneWheelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFortuneWheelPlugin registerWithRegistrar:registrar];
}
@end
