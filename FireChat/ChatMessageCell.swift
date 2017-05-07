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
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    
    }()
    
    var bubbleWidthAnchor:NSLayoutConstraint?
    
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
        
        NSLayoutConstraint.useAndActivateConstraints(constraints:[
            bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8 ),
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),

            bubbleView .heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        
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
