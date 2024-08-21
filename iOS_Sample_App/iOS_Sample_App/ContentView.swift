import SwiftUI
import Combine
import Common

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter text to encode", text: $viewModel.rawText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Encoded Text: \(viewModel.encodedText)")
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
