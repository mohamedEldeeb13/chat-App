//
//  InitialViewController.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTitleAnimation()
        

        
    }
    
    @IBAction func LogInBtn(_ sender: UIButton) {
        let controller = LoginViewController.instantiate(name: .login)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func SignUpBtn(_ sender: UIButton) {
        let controller  = SignUpViewController.instantiate(name: .signUp)
        navigationController?.pushViewController(controller, animated: true)
    }
    

    func showTitleAnimation(){
        titleLbl.text = ""
        var charIndex = 0.0
        let logoText = " Message Me 💬 "
        for letter in logoText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLbl.text?.append(letter)
            }
            charIndex += 1
        }
    }

}
