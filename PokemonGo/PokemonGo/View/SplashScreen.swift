
import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Image("PokemonLogo")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Pokémon")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.primary)
                    .shadow(radius: 10)
                Spacer().frame(height: 100)
            }
        }
    }
}

