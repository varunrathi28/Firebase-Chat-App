//
//  ViewController.swift
//  FireChat
//
//  Created by Varun Rathi on 22/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UITableViewController {

    
    let cellID = "messageCell"
    var messages = [Message]()
    var messageDictionary = [String:Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "create-message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openNewMessage))
        
       checkIfUserLoggedIn()
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
           // observeMessages()
       
    }
    
    
    func observeUserMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else
        {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("timeline").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject]
                {
                    let aMessage = Message()
                    aMessage.setValuesForKeys(dictionary)
                    
                    if let toID = aMessage.toId
                    {
                        self.messageDictionary[toID] = aMessage
                        self.messages = Array(self.messageDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                      self.tableView.reloadData()
                }
              
            }, withCancel: nil)
        
            
        }, withCancel: nil)

    }
    
    
    func observeMessages()
    {
        let ref = FIRDatabase.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
             if let dictionary = snapshot.value as? [String:AnyObject]
            {
                let aMessage = Message()
                aMessage.setValuesForKeys(dictionary)
                
                if let toID = aMessage.toId
                {
                    self.messageDictionary[toID] = aMessage
                    self.messages = Array( self.messageDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    
                    self.tableView.reloadData()
                }
               
            }
            print(snapshot)
        }, withCancel: nil)
    }
    
    
    func checkIfUserLoggedIn()
    {
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            self.perform(#selector(handleLogout), with: nil, afterDelay: 0.1)
            
        }
        else
        {
            checkUserAndSetupNavigationBar()
             observeMessages()
        }
    }
    
    func checkUserAndSetupNavigationBar()
    {
        messages.removeAll()
        messageDictionary.removeAll()
        observeUserMessages()
        
       guard let uid = FIRAuth.auth()?.currentUser?.uid else
       {
        return
        }
        let ref = FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            if let userDic = snapshot.value as? [String : AnyObject]
            {
                self.navigationItem.title = userDic["name"] as? String
            }
            
        }, withCancel: nil)
        
    }
    
    func handleLogout()
    {
        do {
           try  FIRAuth.auth()?.signOut()
        }
        catch let logoutError
        {
            print(logoutError)
        }
        let loginController = LoginViewController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
    
    
    func openNewMessage()
    {
        let newMessageVC = NewMessageController()
        let navC = UINavigationController(rootViewController: newMessageVC)
        present(navC, animated: true, completion: nil)
    }
    
    //MARK :- Tableview datasource and delegates
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        if let toId = message.toId
        {
            let reference = FIRDatabase.database().reference().child("users").child(toId)
            reference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String:AnyObject]
                {
                    cell.textLabel?.text = dic["name"] as? String
                    
                    if let profileImage = dic["profileImageURL"] as? String
                    {
                         cell.profileImageView.loadCachedImageWith(url: profileImage)
                    }
                }
                
            }, withCancel: nil)
            
          
            
          
        }
        
        cell.detailTextLabel?.text = message.text
        
        cell.message = message
        return cell
    }
    
    
}

