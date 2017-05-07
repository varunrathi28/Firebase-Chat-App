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
    let cellID = "msgChatCell"
    
    var messages = [Message]()
    var recipient:User?
    {
        didSet{
            navigationItem.title = recipient?.name
            observeMessages()            
        }
    }
    
    lazy var inputTextField :UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a message..."
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chat Log"
        navigationItem.title = recipient?.name
        setUpInputContainer()
        setUpCollectionView()
    }
    
    func setUpCollectionView()
    {
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 60, right:0 )
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0 )
        
    }
    
    
    func setUpInputContainer()
        {
        
            let containerView = UIView()
            
            containerView.backgroundColor = UIColor.white
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
            let values:[String:Any] = ["text":inputTextField.text!,
                          "toId":toID,
                          "fromId":fromID,
                          "timestamp":timestamp
                          ]
            let reference = FIRDatabase.database().reference().child("messages")
            let childReference = reference.childByAutoId()
            
           // childReference.updateChildValues(values)
            childReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
                
                if error != nil
                {
                    print("FC:Error in Sending messages")
                    return
                }
              
                let timelineReference = FIRDatabase.database().reference().child("timeline").child(fromID!)
                
                // update message in parent message node as well... (Fan out)
                
                let messageID = childReference.key
                timelineReference.updateChildValues([messageID: 1])
                
                let recipientUserRef = FIRDatabase.database().reference().child("timeline").child(toID!)
                recipientUserRef.updateChildValues([messageID:1])
            })
            inputTextField.text = ""
        }
    }
    
    // MARK :- Fetch from Firebase
    
    
    func observeMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else
        {
            return
        }
        
        let userMessages = FIRDatabase.database().reference().child("timeline").child(uid)
        
        userMessages.observe(.childAdded, with: { (snapshot) in
            
            
            let msgId = snapshot.key
            let messageRef = FIRDatabase.database().reference().child("messages").child(msgId)
            
            messageRef.observeSingleEvent(of: .value, with: { (msgSnapshot) in
                
                guard let dic = msgSnapshot.value as? [String:AnyObject] else {
                    return
                }
                
                 let message = Message()
                
                message.setValuesForKeys(dic)
                
                if message.getChatParterID() == self.recipient?.id
                {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
   
                }
                
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
       
    }
    
    
    
    // MARK : - CollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        cell.bubbleWidthAnchor?.constant = getBoundingRectForText(text: message.text!).width + 32
        return cell
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
}

extension ChatLogController:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 80
        if let message = messages[indexPath.row].text
        {
            height = getBoundingRectForText(text: message).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
     func getBoundingRectForText(text:String)->CGRect
    {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
      return   NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16 )], context: nil)
        
    }
    
}
