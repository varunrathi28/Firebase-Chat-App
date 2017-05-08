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
    
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "create-message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openNewMessage))
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          checkIfUserLoggedIn()
    }
    
    
    func observeUserMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else
        {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("timeline").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
        let partnerId = snapshot.key
        let userTimelineRef =  FIRDatabase.database().reference().child("timeline").child(uid).child(partnerId)
        userTimelineRef.observe(.childAdded, with: { (messgeSnapshot) in
            
                let messageId = messgeSnapshot.key
                self.fetchMessageWithMessageID(messageID: messageId)
               
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    // Utility functions for message per user and sorting them according to the time stamp
    
    private  func fetchMessageWithMessageID(messageID:String)
    {
        let messageReference = FIRDatabase.database().reference().child("messages").child(messageID)
        
        messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                let aMessage = Message(dictionary: dictionary)
                
                if let chatPartnerID = aMessage.getChatParterID()
                {
                    self.messageDictionary[chatPartnerID] = aMessage
                }
                self.attemptReload()
            }
            
        }, withCancel: nil)
    }

    func attemptReload()
    {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
    }
    
    func reloadTable()
    {
        self.messages = Array(self.messageDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
        })

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

        }
    }
    
    func checkUserAndSetupNavigationBar()
    {
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else
        {
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(uid)
        ref.observe(.value, with: { (snapshot) in
            
            if let userDic = snapshot.value as? [String : AnyObject]
            {
                let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
                let userImage = UIImageView()
                navigationView.addSubview(userImage)
                
                // User Image
                
                NSLayoutConstraint.useAndActivateConstraints(constraints: [
                    
                    userImage.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
                    userImage.widthAnchor.constraint(equalToConstant:40),
                    userImage.heightAnchor.constraint(equalToConstant:40),
                    userImage.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 10)
                    ])
                
                let userName = UILabel()
                navigationView.addSubview(userName)
                
                NSLayoutConstraint.useAndActivateConstraints(constraints: [
                    
                    userName.leftAnchor.constraint(equalTo: userName.rightAnchor, constant: 10),
                    userName.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
                    ])
                if let name = userDic["name"] as? String
                {
                    userName.text = name
                }
                
                if let imageUrl = userDic["userDic"] as? String
                {
                    userImage.loadCachedImageWith(url: imageUrl)
                }
                
                self.navigationItem.titleView = navigationView
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
    
    func openChatScreenForUser(user:User)
    {
        let chatLogVC = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogVC.recipient = user
        navigationController?.pushViewController(chatLogVC, animated: true)
        
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
        
        
        if let userId:String = message.toId
        {
            let reference = FIRDatabase.database().reference().child("users").child(userId)
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
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        guard let partnerID = message.getChatParterID() else  { return}
        let ref = FIRDatabase.database().reference().child("users").child(partnerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:AnyObject] else {
                return
            }
            let user = User()
            user.id = partnerID
            user.setValuesForKeys(dictionary)
            self.openChatScreenForUser(user: user)
            
        }, withCancel: nil)
    }
    
}

