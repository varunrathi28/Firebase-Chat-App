//
//  LoginViewController.swift
//  FireChat
//
//  Created by Varun Rathi on 22/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {
    
    var messagesController : ChatViewController?
    var containerViewHeightAnchor:NSLayoutConstraint?
    var nameTextFieldHeightAnchor:NSLayoutConstraint?
    var emailTextFieldHeightAnchor:NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:NSLayoutConstraint?

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    var registerButton: UIButton = {
    let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = AppTheme.kColorBackgroundButtonLogin
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5.0
        
        button.addTarget(self, action: #selector(loginRegisterHandler), for: .touchUpInside)
        return button
    }()
    
    let nameTextField:UITextField = {
        let textField = UITextField()
         textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Name"
        textField.clipsToBounds = true
  
    return textField
    }()
    
    let nameSeparatorview : UIView = {
    let view = UIView()
        view.backgroundColor = UIColor(r:220, g:220 ,b:220)
        return view
    }()
    
    let emailTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
         textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.layer.borderColor = AppTheme.kColorBorderTextField.cgColor
        return textField
    }()

    let emailSeparatorview : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220, g:220 ,b:220)
        return view
    }()
    
    let passwordTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.layer.borderColor = AppTheme.kColorBorderTextField.cgColor
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

   lazy var profileImageView:UIImageView = {
    let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
     imgView.image = UIImage(named: "got")
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnProfileImage)))
        return imgView
    }()
    
   lazy var  loginSegmentedControl:UISegmentedControl = {
    let sc = UISegmentedControl(items: ["Login","Register"])
        sc.tintColor = UIColor.white
        sc.addTarget(self, action: #selector(handleSegmentedControl), for: .valueChanged)
        
    return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews()
    {
        view.backgroundColor = AppTheme.kColorBackgroundLogin
        addViewsToHeirarchy()
        addContainerView()
        addRegisterButton()
        setUpImageProfileView()
        setUpLoginSegmentedControl()
    }
    
    
    func handleSegmentedControl()
    {
        let title = loginSegmentedControl.titleForSegment(at: loginSegmentedControl.selectedSegmentIndex)
        registerButton.setTitle(title, for: .normal)
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo:containerView.heightAnchor, multiplier:loginSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo:containerView.heightAnchor, multiplier:loginSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo:containerView.heightAnchor, multiplier:loginSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true

        
        if loginSegmentedControl.selectedSegmentIndex == 0
        {
          containerViewHeightAnchor?.constant = 100
            nameSeparatorview.isHidden = true
               }
        else
        {
              nameSeparatorview.isHidden = false
         containerViewHeightAnchor?.constant = 150
        }
    }
    
    func addViewsToHeirarchy()
    {
        
        view.addSubview(registerButton)
        view.addSubview(profileImageView)
        view.addSubview(loginSegmentedControl)
        view.addSubview(containerView)
    }
    
    func setUpLoginSegmentedControl()
    {
        
        loginSegmentedControl.selectedSegmentIndex = 1 
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            loginSegmentedControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginSegmentedControl.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -12),
            loginSegmentedControl.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            loginSegmentedControl.heightAnchor.constraint(equalToConstant:36)
            
            ])
        
        
    }
    
    func addContainerView()
    {
        containerView.addSubview(nameTextField)
        containerView.addSubview(nameSeparatorview)
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(emailSeparatorview)
        
//        NSLayoutConstraint.useAndActivateConstraints(constraints: [
//            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            ,
//            ,
//             containerView.heightAnchor.constraint(equalToConstant: 150)
//            ])
        
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 150)
        containerViewHeightAnchor?.isActive = true
        addTextField()
    }
    
    func addTextField()
    {
        // Name Text Field
        
        nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 10).isActive = true
        nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier:1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // name separator
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            nameSeparatorview.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            nameSeparatorview.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeparatorview.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            nameSeparatorview.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        // Email text Field
        
        emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        //  emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 10).isActive = true
        emailTextFieldHeightAnchor =   emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier:1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Email separator View
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            emailSeparatorview.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            emailSeparatorview.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSeparatorview.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            emailSeparatorview.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        //Password Text Field x,y,w,h
        
        passwordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 10).isActive = true
        passwordTextFieldHeightAnchor =  passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        nameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func addRegisterButton()
    {
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            registerButton.centerXAnchor.constraint(equalTo:containerView.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            registerButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    func loginRegisterHandler()
    {
        if loginSegmentedControl.selectedSegmentIndex == 0
        {
            handleLogin()
        }
        else{
            handleRegister()
        }
    }

    func setUpImageProfileView()
    {
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            profileImageView.heightAnchor.constraint(equalToConstant:250),
            profileImageView.widthAnchor.constraint(equalToConstant:250 ),
            profileImageView.bottomAnchor.constraint(equalTo: loginSegmentedControl.topAnchor, constant:-5),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant : 20)
            ])
    }
}

extension NSLayoutConstraint
{
    public class func useAndActivateConstraints(constraints:[NSLayoutConstraint])
    {
        for constraint in constraints
        {
            if let view = constraint.firstItem as? UIView
            {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}

extension LoginViewController: UITextFieldDelegate
{
    // MARK :- Text field delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}






