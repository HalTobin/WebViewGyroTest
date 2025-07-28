import SwiftUI
import WebKit
import CoreMotion

class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    let onStateChange: (WebViewState) -> Void
    weak var webView: WKWebView?

    init(onStateChange: @escaping (WebViewState) -> Void) {
        self.onStateChange = onStateChange
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView = webView
        onStateChange(.success)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("controller received: \(message.body)")
        if message.name == "nativeChannel", let body = message.body as? String, body == WebCommands.REQUEST_NATIVE_PERMISSION {
            print("\(WebCommands.REQUEST_NATIVE_PERMISSION) received")
            requestMotionPermission { status in
                let script = "window.onNativePermissionResponse('\(status)')"
                DispatchQueue.main.async {
                    self.webView?.evaluateJavaScript(script, completionHandler: nil)
                }
            }
        }
    }

    private func requestMotionPermission(completion: @escaping (String) -> Void) {
        let manager = CMMotionActivityManager()
        manager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, error in
            if let err = error as NSError?, err.code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                completion("denied")
            } else {
                completion("authorized")
            }
        }
    }
}
