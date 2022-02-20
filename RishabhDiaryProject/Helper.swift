//
//  Helper.swift
//  RishabhDiaryProject
//
//

import Foundation
import UIKit
//Extensio for Converting raw date to simple date string.
extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}
//Extension for creating alert and actitvity indicator view.
extension UIViewController{
    func alertManager(alertControllerTitle:String, message:String, alertActionTitle:String){
        let alertContolelr = UIAlertController(title: alertControllerTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
        alertContolelr.addAction(okAction)
        self.present(alertContolelr, animated: true, completion: nil)
    }
    func showActivityIndicator( indicator:inout UIActivityIndicatorView) {
        indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func hideActivityIndicator(indicator: inout UIActivityIndicatorView){
        indicator.stopAnimating()
    }
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .systemPurple
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
//Extension for setting empty message for table view
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
