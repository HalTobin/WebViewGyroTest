import SwiftUI

struct GyroWebViewScreen: View {
    @State private var pageState: WebViewState = .loading
    @State private var reloadID = UUID() // force GyroWebView to reload

    var body: some View {
        ZStack {
            Group {
                switch pageState {
                case .loading:
                    LoadingView()
                    GyroWebView(
                        id: reloadID,
                        pageState: pageState,
                        onStateChange: { state in
                            pageState = state
                        }
                    )
                case .failed(let errorMessage):
                    FailedView(
                        tryAgain: {
                            pageState = .loading
                            reloadID = UUID()
                        },
                        errorMessage: errorMessage
                    )
                case .success:
                    GyroWebView(
                        id: reloadID,
                        pageState: pageState,
                        onStateChange: { state in
                            pageState = state
                        }
                    )
                }
            }
        }
    }
}
