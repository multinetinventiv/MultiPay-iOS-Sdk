
import UIKit

class MTextField: ACFloatingTextfield {
    
    var isLastInform = false
    var clearButtonColor = UIColor.white
    var originalTextColor:UIColor?
    var tintedClearImage: UIImage?
    
    weak var parentView:InputTextView?
    
    
    func getFieldTitle() -> String {
        guard let text = self.placeholder else {
            return ""
        }
        return text
    }
    
    
    func setErrorMessage(isValid:Bool, message:String? = nil)  {

        if(isValid) {
            self.placeHolderColor = originalTextColor!
        }else{
           self.placeHolderColor = ColorPalette.colorRedCinnabar
        }
        self.lineColor = UIColor.clear
    }
    
    
    fileprivate func tintClearImage() {
        for view in subviews as [UIView] {
            if view is UIButton {
                let button = view as! UIButton
                if let uiImage = button.image(for: .highlighted) {
                    if tintedClearImage == nil {
                       // tintedClearImage = tintImage(uiImage, color: tintColor)
                         tintedClearImage = tintImage(uiImage, color: clearButtonColor)
                    }
                    button.setImage(tintedClearImage, for: UIControl.State())
                    button.setImage(tintedClearImage, for: .highlighted)
                }
            }
        }
    }
    
    
    func tintImage(_ image: UIImage, color: UIColor) -> UIImage {
        let size = image.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(at: CGPoint.zero, blendMode: CGBlendMode.normal, alpha: 1.0)
        
        context!.setFillColor(color.cgColor)
        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.setAlpha(1.0)
        
        let rect = CGRect(
            x: CGPoint.zero.x,
            y: CGPoint.zero.y,
            width: image.size.width,
            height: image.size.height)
        UIGraphicsGetCurrentContext()!.fill(rect)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage!
    }
    
    func placeholderAligment(textAlig:NSTextAlignment) {
        self.textAlignment = textAlig
    }
}
