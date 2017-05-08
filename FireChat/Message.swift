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
    
    
    func getChatParterID()->String?
    {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}

struct ChatEnum {
    
    enum ChatMessageType {
        case eSenderMessage
        case eReceiverMessage
    }
}
