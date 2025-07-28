import SwiftUI
import WebKit
import CoreMotion

struct GyroWebView: UIViewRepresentable {
    let id: UUID
    let pageState: WebViewState
    let onStateChange: (WebViewState) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onStateChange: onStateChange)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webViewConfig = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: WebCommands.REQUEST_NATIVE_PERMISSION)
        
        webViewConfig.userContentController = contentController
        webViewConfig.defaultWebpagePreferences.allowsContentJavaScript = true
        webViewConfig.defaultWebpagePreferences.preferredContentMode = .mobile
        
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.navigationDelegate = context.coordinator
        //webView.uiDelegate = context.coordinator

        if let baseURL = Bundle.main.bundleURL.appendingPathComponent("Web") as URL?,
           let indexURL = URL(string: "index.html", relativeTo: baseURL) {
            print("Loading: \(baseURL)")
            webView.loadFileURL(indexURL, allowingReadAccessTo: baseURL)
        } else {
            onStateChange(.failed(error: "Could not load index.html"))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update needed
    }
    
    func requestMotionPermission() {
        print("GameViewController.requestMotionPermission()")
        CMMotionActivityManager().queryActivityStarting(from: Date(), to: Date(), to: .main) { _, error in
            if let error = error as NSError?, error.code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                print("Motion permission not granted.")
            }
        }
    }
    
}
