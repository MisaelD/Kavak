import Foundation

struct GnomeModel: Decodable {
    let id: Int
    let name: String
    let thumbnail: String
    let age: Int
    let weight: Float
    let height: Float
    let hair_color: String
    let professions: [String]
    let friends: [String]
}
