//
//  FilterModalViewModel.swift
//  Gnome
//
//  Created by saul reyes saavedra on 06/07/20.
//  Copyright © 2020 Misael Delgado Saucedo. All rights reserved.
//

import Foundation

@objc public class FilterModalViewModel: NSObject {
    
    var hairColorFilter : [String]?
    var weightFilter = ["0 to 20","21 to 40","40 >"]
    var heightFilter = ["0 to 40","41 to 80","80 >"]
    let sectionTitles = ["Weight","Height","Hair color"]
    var sectionIsExpanded = [false, false, false]
    var hairColorFilterChecked : [Bool]?
    var weightFilterChecked = [false, false, false]
    var heightFilterChecked = [false, false, false]
    @objc dynamic var filters = ""
    
    
    public init(hairColorFilter: [String]) {
        self.hairColorFilter = hairColorFilter
        self.hairColorFilterChecked = hairColorFilter.map{_ in return false}
    }
    
    func setChecked(section: Int, row: Int, check: Bool){
        
        switch section {
        case 0:
            weightFilterChecked = weightFilterChecked.map{ _ in return false}
            weightFilterChecked[row] =  check
        case 1:
            heightFilterChecked = heightFilterChecked.map{ _ in return false}
            heightFilterChecked[row] =  check
        case 2:
            hairColorFilterChecked = hairColorFilterChecked!.map{ _ in return false}
            hairColorFilterChecked![row] =  check
        default:
            break
        }
    }
    
    func cellIsChecked(section: Int, row: Int) -> Bool{
        switch section {
        case 0:
            return weightFilterChecked[row]
        case 1:
            return heightFilterChecked[row]
        case 2:
            return hairColorFilterChecked![row]
        default:
            return false
        }
    }
}
