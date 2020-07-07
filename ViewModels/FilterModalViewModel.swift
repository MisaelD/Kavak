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
    var ageFilter = ["Less than 100 years", "Older than 100 years"]
    //var heightFilter = ["0 to 80", "80 >"]
    let sectionTitles = ["Age", "Hair color"]
    var sectionIsExpanded = [false, false]
    var hairColorFilterChecked : [Bool]?
    var ageFilterChecked = [false, false]
    //var heightFilterChecked = [false, false, false]
    @objc dynamic var filters : [Dictionary<String, String>] = [[:],[:]]
    
    
    public init(hairColorFilter: [String]) {
        self.hairColorFilter = hairColorFilter
        self.hairColorFilterChecked = hairColorFilter.map{_ in return false}
    }
    
    func setChecked(section: Int, row: Int, check: Bool){
        
        switch section {
        case 0:
            ageFilterChecked = ageFilterChecked.map{ _ in return false}
            ageFilterChecked[row] =  check
        case 1:
            hairColorFilterChecked = hairColorFilterChecked!.map{ _ in return false}
            hairColorFilterChecked![row] =  check
        default:
            break
        }
    }
    
    func cellIsChecked(section: Int, row: Int) -> Bool{
        switch section {
        case 0:
            return ageFilterChecked[row]
        case 1:
            return hairColorFilterChecked![row]
        default:
            return false
        }
    }
    
    func formFilters() {
        
        var filtersAux : [Dictionary<String, String>] = [[:],[:]]
        
        if let index = hairColorFilterChecked!.firstIndex(where: {$0 == true}) {
            //filters.append("Weigh: \(hairColorFilter![index])")
            var emptyDic : Dictionary<String, String> = [:]
            emptyDic["nameFilter"] = "Hair color: \(hairColorFilter![index])"
            emptyDic["filter"] = hairColorFilter![index]
            filtersAux[0] = emptyDic
        }
        
        if let index = ageFilterChecked.firstIndex(where: {$0 == true}) {
            //filters.append("Weigh: \(hairColorFilter![index])")
            var emptyDic : Dictionary<String, String> = [:]
            emptyDic["nameFilter"] = "Age: \(ageFilter[index])"
            emptyDic["filter"] = index == 0 ? "<" : ">"
            filtersAux[1] = emptyDic
        }
        
        filters = filtersAux
    }
}
