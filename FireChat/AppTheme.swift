//
//  AppTheme.swift
//  FireChat
//
//  Created by Varun Rathi on 22/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//


import UIKit


class AppTheme : NSObject
{
    static let kColorBackgroundLogin = UIColor(r: 61, g: 91, b: 151)
    
    static let kColorBackgroundButtonLogin = UIColor(r: 60, g: 101, b: 161)
    
    static let kColorBorderTextField = UIColor(r: 220, g: 220, b: 220)
    
}

extension UIColor
{
    convenience init(r:CGFloat, g:CGFloat ,b:CGFloat)
    {
        
        self.init(red:r/255, green: g/255, blue:b/255, alpha:1)
    }
}
