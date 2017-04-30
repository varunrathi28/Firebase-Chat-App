//
//  ChatLogController.swift
//  FireChat
//
//  Created by Varun Rathi on 27/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController : UICollectionViewController , UITextFieldDelegate
{
    var recipient:User?
    
    lazy var inputTextField :UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a message..."
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat Log"
        collectionView?.backgroundColor = UIColor.white
        navigationItem.title = recipient?.name
        setUpInputContainer()
        
    }
    
    
    func setUpInputContainer()
        {
        
            let containerView = UIView()
           // containerView.backgroundColor = UIColor.red
            containerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(containerView)
            
            
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                containerView.heightAnchor.constraint(equalToConstant: 50),
                containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                containerView.leftAnchor.constraint(equalTo: view.leftAnchor)
               
                ])
            
            
            let sendButton = UIButton(type: .custom)
            sendButton.setTitle("Send", for: .normal)
            sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
           // sendButton.tintColor = UIColor.blue
            sendButton.backgroundColor = UIColor.red
            containerView.addSubview(sendButton)
            
            
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1),
                sendButton.widthAnchor.constraint(equalToConstant: 50)
                ])
          
            containerView.addSubview(inputTextField)
            inputTextField.delegate = self
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                
                inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
                inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor , multiplier:1),
                inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant :0)
                ])
        
            
            let separtorView = UIView()
            containerView.addSubview(separtorView)
            separtorView.backgroundColor = UIColor.lightGray
            
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                separtorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                separtorView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                separtorView.heightAnchor.constraint(equalToConstant: 0.7),
                separtorView.topAnchor.constraint(equalTo: containerView.topAnchor)
                
                ])
            
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func sendMessage()
    {
        if let _ = inputTextField.text?.replacingOccurrences(of: " ", with: "")
        {
            
            let toID = recipient?.id
            let fromID = FIRAuth.auth()?.currentUser?.uid
            let timestamp:NSNumber  = NSNumber(value: NSDate.timeIntervalSinceReferenceDate)
            let values = ["text":inputTextField.text!,
                          "toId":toID,
                          "fromId":fromID,
                          "timestamp":timestamp
                          ] as [String : Any]
            let reference = FIRDatabase.database().reference().child("messages")
            let childReference = reference.childByAutoId()
            
            childReference.updateChildValues(values)
            inputTextField.text = ""
        }
        
      
        
        
    }
    
}

