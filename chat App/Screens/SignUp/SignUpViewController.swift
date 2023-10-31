//
//  SignUpViewController.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupTextFieldsUI()
        
    }
    

    
    @IBAction func SignUpBtn(_ sender: UIButton) {
        
        checkValidation()
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let name = firstName + " " + lastName
        let userAuth = UserAuth(email: email, password: password, name: name)
        checkSignupAuthentication(userAuth)
    }
    
    
    // SignUp function
    
    private func checkSignupAuthentication(_ userAuth: UserAuth){
        FirebaseAuthentication.shared.SignUp(userAuth: userAuth) { error in
            if let error = error {
                UIAlertController.showAlert(msg: error.localizedDescription, form: self)
            }
            if error == nil {
                let controller = VerifySignUPViewController.instantiate(name: .signUp)
                controller.comingUserAuth = userAuth
                self.present(controller, animated: true)
//                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    // function to set up textField and labels
    
    private func setupTextFieldsUI(){
        firstNameLbl.text = ""
        lastNameLbl.text = ""
        emailLbl.text = ""
        passwordLbl.text = ""
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    // function to check validation of textField
    
    private func checkValidation(){
        if firstNameTextField.text != ""{
            if lastNameTextField.text != "" {
                if emailTextField.text != "" {
                    if passwordTextField.text != "" {
                        
                    }else {
                        UIAlertController.showAlert(msg: "Please enter your Password", form: self)
                    }
                }else{
                    UIAlertController.showAlert(msg: "Please enter your Email", form: self)
                }
                
            }else{
                UIAlertController.showAlert(msg: "Please enter your last name", form: self)
            }
            
        }else {
            UIAlertController.showAlert(msg: "Please enter your first name", form: self)
        }
    }

}

// MARK: - Extension for Delegation of TextField

extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        firstNameLbl.text = firstNameTextField.hasText ? "First Name" : ""
        lastNameLbl.text = lastNameTextField.hasText ? "Last Name" : ""
        emailLbl.text = emailTextField.hasText ? "Email" : ""
        passwordLbl.text = passwordTextField.hasText ? "Password" : ""
    }
    
    
}
