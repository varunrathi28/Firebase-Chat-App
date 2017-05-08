//
//  ChatMessageCell.swift
//  FireChat
//
//  Created by Varun Rathi on 08/05/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    
    let textView:UITextView = {
    
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = "Sample Text"
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isScrollEnabled = false
        return tv
    }()
    
    
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.kChatBubbleBlueColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    
    }()
    
    let profileImageView:UIImageView = {
    
        let imageView = UIImageView()
        imageView.image = UIImage(named:"got")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleLeftAnchor:NSLayoutConstraint?
    var bubbleRightAnchor:NSLayoutConstraint?
    
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        
        configureCell()
        
    }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func configureCell()
    {
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        NSLayoutConstraint.useAndActivateConstraints(constraints:[
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:8),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.heightAnchor.constraint(equalToConstant: 32)
            ]
        )
        
        
        NSLayoutConstraint.useAndActivateConstraints(constraints:[
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),

            bubbleView .heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant:8)
        bubbleLeftAnchor?.isActive = false
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true 
        
        NSLayoutConstraint.useAndActivateConstraints(constraints:[
            textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor,constant: 8),
            textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),

            textView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        
        
    }
    
    
}
