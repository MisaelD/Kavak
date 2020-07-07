import Foundation

struct GnomesModel: Decodable {
    let gnomes: [GnomeModel]
}

extension GnomesModel {
    enum CodingKeys: String, CodingKey {
        case gnomes = "Brastlewark"
    }
}
