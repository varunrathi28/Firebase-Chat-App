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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "create-message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openNewMessage))
        
       tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         checkIfUserLoggedIn()
        observeMessages()
    }
    
    
    
    func observeMessages()
    {
        let ref = FIRDatabase.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
             if let dictionary = snapshot.value as? [String:AnyObject]
            {
                let aMessage = Message()
                aMessage.setValuesForKeys(dictionary)
                
                let filterResults = self.messages.filter({ (message) -> Bool in
                    return aMessage.text == message.text
                })
                
                if filterResults.count == 0
                {
                    self.messages.append(aMessage)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
       guard  let uid = FIRAuth.auth()?.currentUser?.uid else
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
//        
//        let chatLogVC = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(chatLogVC, animated: true)
        let newMessageVC = NewMessageController()
        let navC = UINavigationController(rootViewController: newMessageVC)
        present(navC, animated: true, completion: nil)
    }
    
    //MARK :- Tableview datasource and delegates
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MessageCell") as? UserCell
        
    let message = messages[indexPath.row]
        
        
        if let toId = message.toId
        {
            let reference = FIRDatabase.database().reference().child("users").child(toId)
            reference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String:AnyObject]
                {
                    cell. = dic["name"] as? String
                    
                }
                
            }, withCancel: nil)
            
        }
        
        cell.detailTextLabel?.text = message.text
        return cell
    }
    
    
}

