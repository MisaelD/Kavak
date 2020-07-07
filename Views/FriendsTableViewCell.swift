import UIKit
import AlamofireImage

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail : UIImageView!
    @IBOutlet weak var name : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func imageURL(imageURL : String) {
        let url = URL(string: imageURL)
        thumbnail.af.setImage(withURL: url!, placeholderImage: UIImage(named: "ImagePlaceHolder"), completion: { response in
            self.thumbnail!.image = response.value?.af.imageRoundedIntoCircle()
        })
    }
}
