//
//  LoginViewController.swift
//  FireChat
//
//  Created by Varun Rathi on 22/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var messagesController : ChatViewController?
    
    var containerViewHeightAnchor:NSLayoutConstraint!
    
    var nameTextFieldHeightAnchor:NSLayoutConstraint!
     var emailTextFieldHeightAnchor:NSLayoutConstraint!
     var passwordTextFieldHeightAnchor:NSLayoutConstraint!
    
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
    textField.placeholder = "Name"
  
    return textField
    }()
    
    let emailTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        
        textField.layer.borderColor = AppTheme.kColorBorderTextField.cgColor
        return textField
    }()

    let passwordTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.layer.borderColor = AppTheme.kColorBorderTextField.cgColor
        textField.isSecureTextEntry = true
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
        
        containerViewHeightAnchor.isActive = false
       
        emailTextFieldHeightAnchor.isActive = false
        passwordTextFieldHeightAnchor.isActive = false
        
        if loginSegmentedControl.selectedSegmentIndex == 0
        {
           containerViewHeightAnchor.constant = 100
             nameTextFieldHeightAnchor.isActive = false

//            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5)
//            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5)
            
            
        }
        else
        {
            
            containerViewHeightAnchor.constant = 150
            
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
            
        }
        
        nameTextFieldHeightAnchor.isActive = true
        emailTextFieldHeightAnchor.isActive = true
        passwordTextFieldHeightAnchor.isActive = true
        containerViewHeightAnchor.isActive = true
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
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
             containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48),
             containerView.heightAnchor.constraint(equalToConstant: 150)
            ])
        
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 150)
        containerViewHeightAnchor.isActive = true
        addTextField()
    }
    
    func addTextField()
    {
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 10),
            nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
            ])
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 10),
            emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
            ])
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            passwordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 10),
            passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
            ])
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
         emailTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.33)
        
        nameTextFieldHeightAnchor.isActive = true
        passwordTextFieldHeightAnchor.isActive = true
        emailTextFieldHeightAnchor.isActive = true
        
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
    
    func handleLogin()
    {
        guard let email = emailTextField.text , let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user , error) in
            if let uid =  user?.uid
            {
                self.dismiss(animated: true, completion: nil)
                
            }
        })
        
    }
    
        
    func setUpImageProfileView()
    {
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant:30),
            profileImageView.widthAnchor.constraint(equalToConstant:250 ),
            profileImageView.bottomAnchor.constraint(equalTo: loginSegmentedControl.topAnchor, constant: -10)
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






