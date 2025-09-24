
import SwiftUI

struct PokemonsListView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Pokémon")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.primary)
                .padding(.leading, 20)
                .padding(.bottom)
            
            LazyVStack(spacing: 16) {
                ForEach(viewModel.pokemonData) { pokemon in
                    NavigationLink(destination: PokemonProfileView(pokemonName: pokemon.name)
                        .environmentObject(alertViewModel)) {
                            PokemonListView(pokemon: pokemon)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        if pokemon == viewModel.pokemonData.last,
                           !viewModel.isLastPage,
                           !viewModel.isLoading {
                            viewModel.fetchPokemonUsers(alertViewModel: alertViewModel)
                        }
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 5)
    }
}


struct PokemonListView: View {
    let pokemon: PokemonData
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 3)
            
                Text(pokemon.name.capitalized)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
