
//
//  UserCell.swift
//  FireChat
//
//  Created by Varun Rathi on 26/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

import Firebase

class UserCell: UITableViewCell {

    var message:Message?
    {
        didSet
        {
            
            setUpNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue
            {
                let timeDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: timeDate)
            }
            
        }
    }
    
    let profileImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.image = UIImage(named:"got")
        imageView.contentMode = .scaleAspectFill
       
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.layer.masksToBounds = true
        return imageView
    
    }()

    var userMessageType:ChatEnum?
    
    let timeLabel : UILabel = {
    
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
//        profileImageView.snp.makeConstraints { (make) in
//            make.leftMargin.equalTo(8)
//            make.width.equalTo(40)
//            make.height.equalTo(40)
//            make.centerY.equalTo(self)
//        }
        
        
        addSubview(timeLabel)
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            
            timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -20)
            ])
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 56),
            profileImageView.heightAnchor.constraint(equalToConstant: 56)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setUpNameAndProfileImage()
    {
        if let id = message?.getChatParterID()
        {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary  = snapshot.value as? [String:AnyObject]
                {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageURL = dictionary["profileImageURL"] as? String
                    {
                        self.profileImageView.loadCachedImageWith(url: profileImageURL)
                    }
                }
                
            }, withCancel: nil)
            
        }
        
    }
    
    func configureCell()
    {
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 70, y:textLabel!.frame.origin.y - 2, width:(textLabel?.frame.size.width)! , height: (textLabel?.frame.size.height)!)
        
        detailTextLabel?.frame =  CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 2, width:(detailTextLabel?.frame.size.width)! , height: (detailTextLabel?.frame.size.height)!)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView?.backgroundColor = UIColor.green
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func prepareForReuse() {
        profileImageView.image = nil
    }
}
