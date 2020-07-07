//
//  GnomesModel.swift
//  Gnome
//
//  Created by saul reyes saavedra on 03/07/20.
//  Copyright © 2020 Misael Delgado Saucedo. All rights reserved.
//

import Foundation

struct GnomesModel: Decodable {
    let gnomes: [GnomeModel]
}

extension GnomesModel {
    enum CodingKeys: String, CodingKey {
        case gnomes = "Brastlewark"
    }
}
