//
//  LoginViewController.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    
    
    @IBAction func forgetBtn(_ sender: UIButton) {
        forgetPassword()
    }
    
    
  
    
    @IBAction func logInBtn(_ sender: UIButton) {
        
        checkValidation()
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let userAuth = UserAuth(email: email, password: password)
        checkLoginAuthentication(userAuth)
    }
    
    
    private func checkLoginAuthentication(_ userAuth: UserAuth){
        FirebaseAuthentication.shared.LogIn(userAuth: userAuth) { error,isEmailVerfied  in
            if error == nil{
                if isEmailVerfied {
                    self.goToApp()
                }else{
                    UIAlertController.showAlert(msg:"Please check your email and verify your registration" ,form: self)
                }
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription ,form: self)
            }
        }
    }
    
    private func forgetPassword(){
        FirebaseAuthentication.shared.resetPassword(email: emailTextField.text!) { error in
            if error == nil{
                UIAlertController.showAlert(msg: "Reset password email has been sent", form: self)
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription, form: self)
            }
        }
    }
    
    // go to home page
    
    private func goToApp(){
        let controller = UITabBarController.instantiate(name: .home)
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true)
    }
    
    
    // func to setUp labels and textField
    
    private func setupUI(){
        emailLbl.text = ""
        passwordLbl.text = ""
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    
    private func checkValidation(){
        if emailTextField.text != ""{
            if passwordTextField.text != "" {
            
            }else{
                UIAlertController.showAlert(msg: "Please enter your Password", form: self)
            }
            
        }else{
            UIAlertController.showAlert(msg: "Please enter your Email", form: self)
        }
    }
    
    

}


// MARK: - Extension for Delegation of TextField

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLbl.text = emailTextField.hasText ? "Email" : ""
        passwordLbl.text = passwordTextField.hasText ? "Password" : ""
    }
    
    
    
}
