import UIKit

class FilterModalTableViewCell: UITableViewCell {

    @IBOutlet weak var filter : UILabel!
    @IBOutlet weak var arrow : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setExpanded() {
        arrow.image = UIImage(named: "ArrowDown")
    }

    func setCollapsed() {
        arrow.image = UIImage(named: "ArrowRight")
    }
    
    func hideArrow() {
        arrow.isHidden = true
    }
    
    func showArrow() {
        arrow.isHidden = false
    }

}
