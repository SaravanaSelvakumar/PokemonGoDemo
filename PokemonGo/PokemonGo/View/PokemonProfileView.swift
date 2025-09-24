
import SwiftUI

struct PokemonProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var alertViewModel: AlertViewModel
    @StateObject private var viewModel = MainViewModel()
    let pokemonName: String
    
    var body: some View {
        let userName = viewModel.pokemonDetail?.name
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let detail = viewModel.pokemonDetail {
                PokemonDetailView(pokemonDetail: detail)
            } else {
                Text("No user details available.")
                Spacer()
            }
        }
        .padding()
        .navigationTitle(userName ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchPokemonDetail(name: pokemonName, alertViewModel: alertViewModel)
        }
        .alert(isPresented: $alertViewModel.showAlert) {
            Alert(title: Text(alertViewModel.alertTitle),
                  message: Text(alertViewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
        }
    }
}


struct PokemonDetailView: View {
    let pokemonDetail: PokemonDetails
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                
                AsyncImage(url: pokemonDetail.sprites.bestImageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 5)
                
                VStack(spacing: 5) {
                    Text(pokemonDetail.name)
                        .font(.title2)
                        .bold()
                }
                
                
                HStack(spacing: 20) {
                    VStack {
                        Text("\(pokemonDetail.heightString)")
                            .bold()
                        Text("Height")
                            .font(.caption)
                    }
                    VStack {
                        Text("\(pokemonDetail.weightString)")
                            .bold()
                        Text("Weight")
                            .font(.caption)
                    }
                }
                .padding()
                
                VStack(spacing: 8) {
                    Text("Types")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    HStack(spacing: 10) {
                        ForEach(pokemonDetail.types, id: \.slot) { typeElement in
                            Text(typeElement.type.name.capitalized)
                                .font(.caption)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(
                                    Capsule()
                                        .fill(Color.blue.opacity(0.2))
                                )
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
