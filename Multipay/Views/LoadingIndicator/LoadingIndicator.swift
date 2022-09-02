
import UIKit

public class LoadingIndicator {
    private let overlayView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private let backgroundView = UIView()
    
    static var shared = LoadingIndicator()
    func showLoading() {
        if  let window = UIApplication.shared.windows.first {
            backgroundView.frame = window.frame
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            overlayView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height / 2.0)
            overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
            if #available(iOS 13.0, *) {
                activityIndicator.style = .large
            } else {
                activityIndicator.style = .gray
            }
            
            backgroundView.addSubview(overlayView)
            
            overlayView.addSubview(activityIndicator)
            window.addSubview(backgroundView)
            
            activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        backgroundView.removeFromSuperview()
    }
}
