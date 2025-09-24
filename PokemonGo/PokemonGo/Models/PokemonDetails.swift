
import Foundation

struct PokemonDetails: Codable {
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeElement]
    let sprites: Sprites
    
    var heightString: String {
          "\(height)"
      }
      
      var weightString: String {
          "\(weight)"
      }
}

struct PokemonTypeElement: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
    let url: String
}


struct Sprites: Codable {
    let frontDefault: String?
    let other: OtherSprites?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
    
    var bestImageURL: URL? {
        if let homeImage = other?.home.frontDefault {
            return URL(string: homeImage)
        }
        if let dreamWorldImage = other?.dreamWorld.frontDefault {
            return URL(string: dreamWorldImage)
        }
        if let defaultImage = frontDefault {
            return URL(string: defaultImage)
        }
        return nil
    }
}


struct OtherSprites: Codable {
    let dreamWorld: DreamWorldSprites
    let home: HomeSprites
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case home
    }
}

struct DreamWorldSprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct HomeSprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

