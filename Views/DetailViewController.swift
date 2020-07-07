import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var nameLabel : UILabel!
    
    var detailViewModel : DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = detailViewModel?.gnome?.name ?? ""
    }
    
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Professions"
        default:
            return "Friends"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (detailViewModel?.gnome != nil) else {
            return 0
        }
        
        switch section {
        case 0:
            return 1
        case 1:
            if detailViewModel?.gnome?.professions.count == 0 {
                return 1
            }else {
                return (detailViewModel?.gnome?.professions.count)!
            }
        case 2:
            if detailViewModel?.gnome?.friends.count == 0 {
                return 1
            }else {
                return (detailViewModel?.gnome?.friends.count)!
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 380
        case 1:
            return 70
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
            cell.age.text = detailViewModel?.getAge()
            cell.hairColor.text = detailViewModel?.getHairColor()
            cell.height.text = detailViewModel?.getHeight()
            cell.weight.text = detailViewModel?.getWeigth()
            cell.imageURL(imageURL: detailViewModel?.gnome?.thumbnail ?? "")
            return cell
        
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionsTableViewCell", for: indexPath) as! ProfessionsTableViewCell
            
            if (detailViewModel?.gnome?.professions.count)! == 0{
                cell.profession.text = "Has no profession"
            }else{
                cell.profession.text = detailViewModel?.gnome?.professions[indexPath.row]
            }
            return cell
        
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
            
            if (detailViewModel?.gnome?.friends.count)! == 0{
                cell.name.text = "Has no friends"
            }else{
                cell.name.text = detailViewModel?.friends?[indexPath.row].name ?? ""
                cell.imageURL(imageURL: detailViewModel?.friends?[indexPath.row].thumbnail ?? "")
            }
            return cell
        }
    }
}
