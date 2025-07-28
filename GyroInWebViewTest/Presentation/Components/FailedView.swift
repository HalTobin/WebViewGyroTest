import SwiftUI

struct FailedView: View {
    let tryAgain: () -> Void
    let errorMessage: String
    
    var body: some View {
        return VStack {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
            Text("Couldn't load WebView.")
                .font(.headline)
                .padding()
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(.red)
                .padding()
            Button("Try again", systemImage: "arrow.clockwise", action: tryAgain)
        }
    }
}
