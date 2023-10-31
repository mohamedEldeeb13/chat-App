//
//  User.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Equatable{
    var id: String = ""
    var pushId: String = ""
    var imageLink: String = ""
    var name, email, status: String
    
    static func == (lhs: User, rhs: User) -> Bool{
        lhs.id == rhs.id
    }
}

struct UserAuth{
    var email: String
    var password: String
    var name: String?

}
