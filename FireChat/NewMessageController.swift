//
//  NewMessageController.swift
//  FireChat
//
//  Created by Varun Rathi on 24/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    var messagesController : ChatViewController?
    var arrUsers = [User]()
    let cellID = "newMessageCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID )
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pressedCancel))
        
        fetchUsers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        
    }
    
    func fetchUsers()
    {
        let ref = FIRDatabase.database().reference().child("Users")
        
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
           if let val = snapshot.value as? [String : AnyObject]
           {
            let user = User(name: val["name"] as! String, email: val["email"] as! String, profileImageUrl: val["profileImageURL"] as! String,id:snapshot.key)
            
            self.arrUsers.append(user)
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            }
            
        }, withCancel: nil)
        
        
    }
    
    func pressedCancel()
    {
        dismiss(animated: true, completion: nil)
    } 
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let user = arrUsers[indexPath.row]
        cell.textLabel?.text = "\(user.name!)"
        cell.detailTextLabel?.text = "\(user.email!)"
       if  let url = user.profileImageUrl
       {
            cell.profileImageView.loadCachedImageWith(url: url)
        }
        
      
        return cell
        
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(64)
    }
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let selectedUser = arrUsers[indexPath.row]
    let chatLogVC = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
    chatLogVC.recipient = selectedUser
    navigationController?.pushViewController(chatLogVC, animated: true)
    
    
    }
    
}


