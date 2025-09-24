
import SwiftUI
import Observation
import Foundation

class MainViewModel: ObservableObject {
    @Published var pokemonData: [PokemonData] = []
    @Published var pokemonDetail: PokemonDetails?
    @Published var isLoading: Bool = false
    @Published var isLastPage: Bool = false
    @Published var currentPage: Int = 1
    
    let perPage: Int = 20
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon"
    
    
    func fetchPokemonUsers(alertViewModel: AlertViewModel, isInitialLoad: Bool = false) {
        guard !isLoading, !isLastPage else { return }
        
        let offset = (currentPage - 1) * perPage
        guard let url = URL(string: "\(baseUrl)?limit=\(perPage)&offset=\(offset)") else {
            alertViewModel.displayAlert(message: "Invalid URL")
            return
        }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    alertViewModel.displayAlert(message: error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    alertViewModel.displayAlert(message: "No data received from server.")
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(PokemonResponse.self, from: data)
                    
                    if isInitialLoad {
                        self.pokemonData = response.results
                    } else {
                        self.pokemonData.append(contentsOf: response.results)
                    }
                    
                    self.isLastPage = response.next == nil
                    self.currentPage += 1
                } catch {
                    alertViewModel.displayAlert(message: "Failed to decode Pokémon list.")
                    print("Error decoding Pokémon list: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchPokemonDetail(name: String, alertViewModel: AlertViewModel) {
        guard let url = URL(string: "\(baseUrl)/\(name)") else {
            alertViewModel.displayAlert(message: "Invalid URL")
            return
        }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    alertViewModel.displayAlert(message: error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    alertViewModel.displayAlert(message: "No data received from server.")
                    return
                }
                
                do {
                    let detail = try JSONDecoder().decode(PokemonDetails.self, from: data)
                    self.pokemonDetail = detail
                } catch {
                    alertViewModel.displayAlert(message: "Failed to decode Pokémon details.")
                    print("Error decoding Pokémon detail JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func resetData() {
        currentPage = 1
        isLastPage = false
        pokemonData.removeAll()
    }
}

