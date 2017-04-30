//
//  User.swift
//  FireChat
//
//  Created by Varun Rathi on 24/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

class User: NSObject {

    var name:String!
    var email:String!
    var profileImageUrl:String!
    var id:String!
    
    init(name:String , email:String, profileImageUrl:String, id:String)
    {
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.id = id
    }
    

    
}
