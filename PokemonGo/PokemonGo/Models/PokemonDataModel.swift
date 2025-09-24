
import Foundation


struct PokemonResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonData]
}

struct PokemonData: Identifiable,Equatable, Codable {
    let name: String
    let url: String
    var id: Int {
        Int(url.split(separator: "/").last ?? "0") ?? 0
    }
}
 
