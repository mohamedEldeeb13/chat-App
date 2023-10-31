//
//  FirebaseAuthManager.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation
import FirebaseAuth

class FirebaseAuthentication{
    
    static let shared = FirebaseAuthentication()
    
    var currntId: String{
        return Auth.auth().currentUser!.uid
    }
    var currentUser: User? {
        if Auth.auth().currentUser != nil{
            let fetchedData = UserDefaultManager.shared.fetchLocalUser()
            return fetchedData
        }else{
            return nil
        }
    }
    
    func LogIn(userAuth: UserAuth, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool)->(Void)){
        Auth.auth().signIn(withEmail: userAuth.email, password: userAuth.password) {authResult, error in
            if error == nil && authResult!.user.isEmailVerified{
                if authResult?.user != nil {
                    let user = User(id: authResult!.user.uid, pushId: "", imageLink: "", name: userAuth.name ?? "", email: userAuth.email, status: "")
                    FirestoreManager.shared.FirestorReference(.User).document(user.id).getDocument { document, error in
                        if let document = document{
                            if !(document.exists) {
                                FirestoreManager.shared.saveUserToFirestore(user)
                                UserDefaultManager.shared.saveUserLocally(user)
                            }
                        }
                    }
                }
                completion(error,true)
                FirestoreManager.shared.downloadUserFormFirestore(userId: authResult!.user.uid)
            }else {
                completion(error,false)
            }
        }
    }
    
    //Sign Up Authentication
    func SignUp(userAuth: UserAuth, completion: @escaping (_ error: Error?)->Void){
        Auth.auth().createUser(withEmail: userAuth.email, password: userAuth.password) { authResult, error in
            if let error = error {
                completion(error)
            }else{
                authResult!.user.sendEmailVerification{ error in
                    completion(error)
                }
            }
            
            if authResult?.user != nil {
                let user = User(id: authResult!.user.uid, pushId: "", imageLink: "", name: userAuth.name ?? "", email: userAuth.email, status: "")
                if authResult!.user.isEmailVerified{
                    FirestoreManager.shared.saveUserToFirestore(user)
                    UserDefaultManager.shared.saveUserLocally(user)
                }
                
            }
            
        }
    }
    
    
    
    func resendVerificationEmail(email:String, completion: @escaping(_ error: Error?) -> Void){
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    func LogOut(completion: @escaping (_ error: Error?) -> (Void)){
        do{
            try Auth.auth().signOut()
            UserDefaultManager.shared.removeLocalUser()
            completion(nil)
        }catch let error as NSError{
            completion(error)
        }
    }
    
}
