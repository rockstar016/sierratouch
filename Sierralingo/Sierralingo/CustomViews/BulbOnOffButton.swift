import UIKit

class BulbOnOffButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "light_on")! as UIImage
    let uncheckedImage = UIImage(named: "light_off")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.isChecked = false
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        self.isChecked = false
    }
}
