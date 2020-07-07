//
//  FiltersModalViewController.swift
//  Gnome
//
//  Created by saul reyes saavedra on 06/07/20.
//  Copyright © 2020 Misael Delgado Saucedo. All rights reserved.
//

import UIKit

class FiltersModalViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    var filterModalViewModel : FilterModalViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filter(){
        //self.dismiss(animated: true, completion: nil)
        filterModalViewModel?.filters = "hola"
    }
}

extension FiltersModalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (filterModalViewModel?.sectionTitles.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return filterModalViewModel!.sectionIsExpanded[section] ? (1+(filterModalViewModel?.weightFilter.count)!) : 1
        case 1:
            return filterModalViewModel!.sectionIsExpanded[section] ? (1+(filterModalViewModel?.heightFilter.count)!) : 1
        case 2:
            return filterModalViewModel!.sectionIsExpanded[section] ? (1+(filterModalViewModel?.hairColorFilter?.count)!) : 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterModalTableViewCell", for: indexPath) as! FilterModalTableViewCell
        
        if indexPath.row == 0 {
            
            cell.filter.text = filterModalViewModel?.sectionTitles[indexPath.section]
            
            if (filterModalViewModel?.sectionIsExpanded[indexPath.section])! {
                cell.setExpanded()
            } else {
                cell.setCollapsed()
            }
            cell.showArrow()
            return cell
        } else {
            
            switch indexPath.section {
            case 0:
                cell.filter.text = filterModalViewModel?.weightFilter[indexPath.row-1]
            case 1:
                cell.filter.text = filterModalViewModel?.heightFilter[indexPath.row-1]
            case 2:
                cell.filter.text = filterModalViewModel?.hairColorFilter![indexPath.row-1]
            default:
                break
            }
            cell.accessoryType = (filterModalViewModel?.cellIsChecked(section: indexPath.section, row: indexPath.row-1))! ? .checkmark : .none
            cell.hideArrow()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            filterModalViewModel!.sectionIsExpanded[indexPath.section] = !filterModalViewModel!.sectionIsExpanded[indexPath.section]
            tableView.reloadSections([indexPath.section], with: .automatic)
        } else {
            let cell = tableView.cellForRow(at: indexPath)
            
            if cell!.accessoryType == .checkmark {
                cell!.accessoryType = .none
            } else {
                resetChecks(section: indexPath.section)
                cell!.accessoryType = .checkmark
            }
            filterModalViewModel?.setChecked(section: indexPath.section, row: indexPath.row-1, check: cell!.accessoryType == .checkmark)
        }
    }
}

extension FiltersModalViewController {
    func resetChecks(section: Int) {
        for j in 0..<tableView.numberOfRows(inSection: section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: j, section: section)) {
                cell.accessoryType = .none
            }
        }
    }
}

