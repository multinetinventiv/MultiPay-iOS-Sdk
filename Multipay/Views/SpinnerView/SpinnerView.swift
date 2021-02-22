
import UIKit

import NVActivityIndicatorView

class SpinnerView: BaseView {

    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var lblMessage: MTLabel!

    var isInTheMainWindow : Bool = false
    
    func showSpinner(_ text:String){
        
        
    }
    init(frame: CGRect,text:String,isInMainwindow:Bool = true) {
        
        super.init(frame: frame)
        setupView()
        if !text.isEmpty {
            lblMessage.text = text
        }
        self.isInTheMainWindow = isInMainwindow
    }
    
    
    init(view: UIView,text:String,isInMainwindow:Bool = false) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT))
        setupView()
        if !text.isEmpty {
            lblMessage.text = text
        }
        self.isInTheMainWindow = isInMainwindow
        
        if(isInTheMainWindow) {
            let window =  UIApplication.shared.windows.last
            window?.addSubview(self)
        }else{
             view.addSubview(self)
        }
    }
    
    internal required init(frame: CGRect) {
        super.init(frame: frame)
         setupView()
    }
    
    
    // MARK: - NSCoding
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       setupView()
    }
    


    
    fileprivate func setupView(){
        //self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        //activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.width = 1.5
        //activityIndicatorView.color = UIColor.whiteColor()
        activityIndicatorView.backgroundColor = ColorPalette.spinnerView.activityIndicatorViewBackgroundColor
        activityIndicatorView.type = NVActivityIndicatorType.circleStrokeSpin
        activityIndicatorView.startAnimating()
        lblMessage.isHidden = ServiceUrl.isPROD()
    }
}
