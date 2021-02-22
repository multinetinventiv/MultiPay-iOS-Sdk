
import UIKit
import Foundation

class MTLabel: UILabel {


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    func setup(){
        self.textColor = UIColor.white
        self.font = FontHelper.MTLabel.label
    }
    func setProperties(_ borderWidth: Float, borderColor: UIColor) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
    }
    func setFontAndTextColor(font:UIFont = FontHelper.MTLabel.label, textColor:UIColor =  ColorPalette.MTLabel.label){
        self.textColor = textColor
        self.font = font
    }
}
