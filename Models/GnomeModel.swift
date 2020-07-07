//
//  GnomeModel.swift
//  Gnome
//
//  Created by saul reyes saavedra on 03/07/20.
//  Copyright © 2020 Misael Delgado Saucedo. All rights reserved.
//

import Foundation
//import MapKit

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
