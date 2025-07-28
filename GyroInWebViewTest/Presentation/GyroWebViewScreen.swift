import SwiftUI

struct GyroWebViewScreen: View {
    @State private var pageState: WebViewState = .loading
    @State private var reloadID = UUID()

    var body: some View {
        ZStack {
            if case .failed = pageState {
                EmptyView()
            } else {
                GyroWebView(
                    id: reloadID,
                    pageState: pageState,
                    onStateChange: { state in
                        pageState = state
                    }
                )
            }
            Group {
                switch pageState {
                case .loading:
                    LoadingView()
                case .failed(let errorMessage):
                    FailedView(
                        tryAgain: {
                            pageState = .loading
                            reloadID = UUID()
                        },
                        errorMessage: errorMessage
                    )
                case .success:
                    EmptyView()
                }
            }
        }
    }
}
