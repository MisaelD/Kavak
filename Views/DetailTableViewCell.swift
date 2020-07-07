import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var thumbnail : UIImageView!
    @IBOutlet var age : UILabel!
    @IBOutlet var weight : UILabel!
    @IBOutlet var height : UILabel!
    @IBOutlet var hairColor : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func imageURL(imageURL : String){
        let url = URL(string: imageURL)
        thumbnail.af.setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceHolder"))
    }
}
