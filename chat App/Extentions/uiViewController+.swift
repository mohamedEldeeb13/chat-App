//
//  uiViewController+.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation
import UIKit

extension UIViewController{
    static var identifire: String{
       return String(describing: self)
    }
    static func instantiate(name: StoryboardEnum) -> Self{
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifire) as! Self
        return controller
        
    }
    
    enum StoryboardEnum: String {
        case initial = "Initial"
        case login = "Login"
        case signUp = "SignUp"
        case home = "Home"
        case editProfile = "EditProfile"
        case status = "Status"
        
    }
    
}
