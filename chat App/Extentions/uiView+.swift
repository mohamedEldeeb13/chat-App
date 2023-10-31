//
//  uiView+.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation
import UIKit

extension UIView{
    @IBInspectable var cornerRedius: CGFloat{
        get{
            return self.cornerRedius
            
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
