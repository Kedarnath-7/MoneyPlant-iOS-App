import UIKit

class CollectionViewCell2: UICollectionViewCell {
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var nameLabel2: UILabel!
    
    
    
    func configure(with image: UIImage) {
        imageView2.image = image
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Set border color, width, and corner radius for the imageView
            imageView2.layer.borderColor = UIColor.lightGray.cgColor
            imageView2.layer.borderWidth = 2.0
            imageView2.layer.cornerRadius = 8.0
            imageView2.clipsToBounds = true        }
    
}
