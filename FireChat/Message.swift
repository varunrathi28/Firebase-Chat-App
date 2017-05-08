//
//  Message.swift
//  FireChat
//
//  Created by Varun Rathi on 01/05/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Firebase


class Message: NSObject {

    
    var fromId:String?
    var toId:String?
    var text:String?
    var timestamp:NSNumber?
    var imageURL:String?
    var imageHeight:NSNumber?
    var imageWidth:NSNumber?
    
    func getChatParterID()->String?
    {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
    init(dictionary:[String:AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        imageURL = dictionary["imageURL"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
    
}

struct ChatEnum {
    
    enum ChatMessageType {
        case eSenderMessage
        case eReceiverMessage
    }
}
