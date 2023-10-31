//
//  userDefaultManager.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation

class UserDefaultManager{
    
    static let shared = UserDefaultManager()
    
    let key = "currentUser"
    let userDefault = UserDefaults.standard
    func saveUserLocally(_ user: User){
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(user){
            userDefault.set(data, forKey: key )
        }
    }
    func fetchLocalUser () -> User? {
        if let data = userDefault.data(forKey: key){
            let userObj =  decodeData(data: data)
            return userObj
        }
        return nil
    }
    private func decodeData(data: Data) -> User?{
        let decoder = JSONDecoder()
        do{
            let userObject = try decoder.decode(User.self, from: data)
            return userObject
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    func removeLocalUser (){
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }
}
