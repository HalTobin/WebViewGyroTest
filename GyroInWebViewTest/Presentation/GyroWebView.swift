import SwiftUI
import WebKit

struct GyroWebView: UIViewRepresentable {
    let id: UUID
    let pageState: WebViewState
    let onStateChange: (WebViewState) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onStateChange: onStateChange)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webViewConfig = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.navigationDelegate = context.coordinator

        if let baseURL = Bundle.main.bundleURL.appendingPathComponent("Web") as URL?,
           let indexURL = URL(string: "index.html", relativeTo: baseURL) {
            webView.loadFileURL(indexURL, allowingReadAccessTo: baseURL)
        } else {
            onStateChange(.failed(error: "Could not load index.html"))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update needed
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let onStateChange: (WebViewState) -> Void

        init(onStateChange: @escaping (WebViewState) -> Void) {
            self.onStateChange = onStateChange
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            onStateChange(.loading)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onStateChange(.success)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            onStateChange(.failed(error: error.localizedDescription))
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            onStateChange(.failed(error: error.localizedDescription))
        }
    }
}
