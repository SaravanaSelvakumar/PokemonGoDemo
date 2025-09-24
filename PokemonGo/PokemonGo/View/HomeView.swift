
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject var alertViewModel: AlertViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        if viewModel.pokemonData.isEmpty {
                            ProgressView("Loading Pokemons...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            PokemonsListView(viewModel: viewModel)
                                .environmentObject(alertViewModel)
                            
                        }
                    }
                }
                .refreshable {
                    viewModel.resetData()
                    if viewModel.pokemonData.isEmpty {
                        viewModel.fetchPokemonUsers(alertViewModel: alertViewModel, isInitialLoad: true)
                    }
                }
            }
            
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $alertViewModel.showAlert) {
            Alert(title: Text(alertViewModel.alertTitle),
                  message: Text(alertViewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if viewModel.pokemonData.isEmpty {
                viewModel.fetchPokemonUsers(alertViewModel: alertViewModel, isInitialLoad: true)
            }
        }
    }
}
