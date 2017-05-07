//
//  LoginViewController+Handlers.swift
//  FireChat
//
//  Created by Varun Rathi on 26/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

extension LoginViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func handleTapOnProfileImage()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage:UIImage!
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            selectedImage = editedImage
        }
        else if let  originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            selectedImage = originalImage
        }
        profileImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Firebase Handlers
    
    
    func handleLogin()
    {
        guard let email = emailTextField.text , let password = passwordTextField.text else {
            return
        }
        HUD.show(.progress)
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user , error) in
            if let uid =  user?.uid
            {
                HUD.hide({ (value) in
                    
                    if value
                    {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
                
                
            }
        })
        
    }
    
    
    
    func handleRegister()
    {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        HUD.show(.progress)
        
        FIRAuth.auth()?.createUser(withEmail:email, password:password, completion: { (user:FIRUser?, error) in
            
            if error != nil
            {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // Success authentication
            
            
            let imageName = NSUUID().uuidString
            let imageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            let imageData = UIImagePNGRepresentation(self.profileImageView.image!)
            
            imageRef.put(imageData!, metadata: nil, completion: { (metadata, error) in
                
                if error != nil
                {
                    print(error)
                    return
                }
                
                if let downloadUrl = metadata?.downloadURL()?.absoluteString
                {
                    let values = ["name":name, "email":email, "profileImageURL":downloadUrl]
                    self.registerUserWithID(uid: uid, values: values as [String : AnyObject])
                    
                }
                
                
            })
            
            
            
            
        })
    }
    
    private    func registerUserWithID(uid:String , values:[String:AnyObject])
    {
        let reference = FIRDatabase.database().reference()
        let childRef = reference.child("Users").child(uid)
        
        childRef.updateChildValues(values, withCompletionBlock: { (err, reference) in
            
            if err != nil
            {
                print(err)
                return
            }
            print("Saved user successfully into Firebase db")
            
            HUD.hide({ (value) in
                
                if value
                {
                    self.messagesController?.checkUserAndSetupNavigationBar()
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        })
    }
}
