

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    @StateObject var alertViewModel = AlertViewModel()
    @State private var showSplash = true

    
    var body: some View {
        Group {
            if showSplash {
                SplashScreen()
                    .environmentObject(alertViewModel)
            } else {
                HomeView()
                    .environmentObject(alertViewModel)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
