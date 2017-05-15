//
//  Chat.swift
//  FireChat
//
//  Created by Varun Rathi on 11/05/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

class ChatInputContainerView : UIView
{
    
    lazy var inputTextField :UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter message..."
        textField.delegate = self
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            heightAnchor.constraint(equalToConstant: 50),
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            leftAnchor.constraint(equalTo: view.leftAnchor)
            
            ])
        
        addSubview(uploadImageIcon)
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            
            uploadImageIcon.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            uploadImageIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            uploadImageIcon.widthAnchor.constraint(equalToConstant: 32),
            uploadImageIcon.heightAnchor.constraint(equalToConstant: 32)
            ])
        
        
        // store a reference to bottom anchor (Use it for shifting in case of keyboards)
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        
        let sendButton = UIButton(type: .custom)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        // sendButton.tintColor = UIColor.blue
        sendButton.setTitleColor(UIColor.blue, for: .normal)
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
            
            inputTextField.leftAnchor.constraint(equalTo: uploadImageIcon.rightAnchor, constant: 8),
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatInputContainerView : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
