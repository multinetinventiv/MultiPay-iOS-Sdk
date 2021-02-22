

import UIKit

enum InputToolBarType {
    case next
    case done
}

class InputToolBar: BaseView {

    //Outlets
    
    @IBOutlet weak var inputToolBarBackgroundView: UIView!
    @IBOutlet weak var inputToolBarNextIcon: UIImageView!
    @IBOutlet weak var inputToolBarNextButton: UIButton!
    @IBOutlet weak var inputToolBarDoneButton: UIButton!
    
    //Variables
    var completionHandlerNextButton:(()->Void)?
    var completionHandlerDoneButton:(()->Void)?
    
    
    //MARK: - InitView
    func initView(type:InputToolBarType?) {
        
        if type != .next {
            inputToolBarNextIcon.isHidden = true
        }
        
        inputToolBarDoneButton.setTitle(Localization.Done.local, for: .normal)
        inputToolBarDoneButton.setTitleColor(ColorPalette.colorGrayMakoToolbar(), for: .normal)
        
        //inputToolBarNextIcon.image = inputToolBarNextIcon.image!.withRenderingMode(.alwaysTemplate)
        //inputToolBarNextIcon.tintColor = .white//ColorPalette.colorGrayMako
        //inputToolBarBackgroundView.backgroundColor = ColorPalette.colorGrayMako
    }
    
    func setInputToolBarDoneButtonTitle(_ title:String)  {
        inputToolBarDoneButton.setTitle(title, for: .normal)
    }

    //MARK: Buttons
    @IBAction func inputToolBarNextButtonClicked(_ sender: Any) {
        self.completionHandlerNextButton?()
    }
    
    @IBAction func inputToolBarDoneButtonClicked(_ sender: Any) {
        self.completionHandlerDoneButton?()
    }
    
}
