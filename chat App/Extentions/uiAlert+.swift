//
//  uiAlert.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation
import UIKit

extension UIAlertController{
    static func showAlert(msg:String, form controller: UIViewController){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        controller.present(alert, animated: true)
    }
}
