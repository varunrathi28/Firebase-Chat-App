//
//  ChatLogController.swift
//  FireChat
//
//  Created by Varun Rathi on 27/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class ChatLogController : UICollectionViewController , UITextFieldDelegate, UINavigationControllerDelegate,ChatCellProtocol
{
    let cellID = "msgChatCell"
    
    var messages = [Message]()
    var recipient:User?
    {
        didSet{
            navigationItem.title = recipient?.name
            observeMessages()            
        }
    }
    
    var containerViewBottomAnchor:NSLayoutConstraint?
    
   lazy var  uploadImageIcon : UIImageView = {
    
        let imageview = UIImageView()
        imageview.image = UIImage(named: "upload")
        imageview.isUserInteractionEnabled = true
        imageview.contentMode = .scaleAspectFill
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImage)))
        return imageview
    }()
   
    
    lazy var inputTextField :UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter message..."
        textField.delegate = self
        return textField
    }()
    
    lazy var inputContainerView:UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter some Text..."
  //      inputTextField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-50, height: 50)
        
        let sendButton = UIButton(type: .custom)
        sendButton.setTitle("Send", for: .normal)
       
        // sendButton.tintColor = UIColor.blue
        sendButton.setTitleColor(UIColor.blue, for: .normal)
        
        containerView.addSubview(inputTextField)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1),
            //sendButton.widthAnchor.constraint(equalToConstant: 50)
            sendButton.leftAnchor.constraint(equalTo: inputTextField.rightAnchor)
            ])
        
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        inputTextField.delegate = self
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            
            inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor , multiplier:1),
            inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant :0)
            ])
        
        
        let separtorView = UIView()
        containerView.addSubview(separtorView)
        separtorView.backgroundColor = UIColor.lightGray
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            separtorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            separtorView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            separtorView.heightAnchor.constraint(equalToConstant: 0.7),
            separtorView.topAnchor.constraint(equalTo: containerView.topAnchor)
            
            ])

        containerView.addSubview(inputTextField)
        return containerView
    
    }()
    
    
 
    
//   override var inputAccessoryView: UIView?
//   {
//    
//    get
//    {
//      //  return inputContainerView
//    }
//    
//    }

    override var canBecomeFirstResponder: Bool
    {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chat Log"
        navigationItem.title = recipient?.name
        
        setUpCollectionView()
        
        setUpInputContainer()
        setUpKeyBoard()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deRegisterKeyboardNotifications()
    }
    
    // MARK: - Collection view properties
    
    func setUpCollectionView()
    {
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom:58, right:0 )
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0 )
        collectionView?.keyboardDismissMode = .interactive
        
    }
    
    //MARK : - Keyboard
    
    func setUpKeyBoard()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(notification:Notification)
    {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        
        self.containerViewBottomAnchor?.constant = -keyboardFrame!.height
         UIView.animate(withDuration: keyboardDuration!) { 
            self.view.layoutIfNeeded()
        }
        
        if messages.count > 0
        {
            let indexpath = IndexPath(item: self.messages.count-1, section: 0)
            collectionView?.scrollToItem(at: indexpath, at: .bottom, animated: true)
        }
    }
    
    func handleKeyboardWillHide(notification:Notification)
    {
          let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }


    }
    
    func deRegisterKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK :- Chat View Functions
    
    func setUpInputContainer()
        {
        
            let containerView = UIView()
            containerView.backgroundColor = UIColor.white
            containerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(containerView)
            
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                containerView.heightAnchor.constraint(equalToConstant: 50),
                containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                containerView.leftAnchor.constraint(equalTo: view.leftAnchor)
               
                ])
            
            containerView.addSubview(uploadImageIcon)
            
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                
                uploadImageIcon.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                uploadImageIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                uploadImageIcon.widthAnchor.constraint(equalToConstant: 32),
                uploadImageIcon.heightAnchor.constraint(equalToConstant: 32)
                ])
          
            
            // store a reference to bottom anchor (Use it for shifting in case of keyboards)
            
            containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            containerViewBottomAnchor?.isActive = true
            
            
            let sendButton = UIButton(type: .custom)
            sendButton.setTitle("Send", for: .normal)
            sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
           // sendButton.tintColor = UIColor.blue
            sendButton.setTitleColor(UIColor.blue, for: .normal)
            containerView.addSubview(sendButton)
            
            
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1),
                sendButton.widthAnchor.constraint(equalToConstant: 50)
                ])
          
            containerView.addSubview(inputTextField)
            inputTextField.delegate = self
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                
                inputTextField.leftAnchor.constraint(equalTo: uploadImageIcon.rightAnchor, constant: 8),
                inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor , multiplier:1),
                inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant :0)
                ])
        
            let separtorView = UIView()
            containerView.addSubview(separtorView)
            separtorView.backgroundColor = UIColor.lightGray
            
            NSLayoutConstraint.useAndActivateConstraints(constraints: [
                separtorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                separtorView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                separtorView.heightAnchor.constraint(equalToConstant: 0.7),
                separtorView.topAnchor.constraint(equalTo: containerView.topAnchor)
                
                ])
            
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
    // MARK :- Fetch from Firebase
    
    
    func observeMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let partnerId = recipient?.id else
        {
            return
        }
        
        let userMessages = FIRDatabase.database().reference().child("timeline").child(uid).child(partnerId)
        
        userMessages.observe(.childAdded, with: { (snapshot) in
            
            
            let msgId = snapshot.key
            let messageRef = FIRDatabase.database().reference().child("messages").child(msgId)
            
            messageRef.observeSingleEvent(of: .value, with: { (msgSnapshot) in
                
                guard let dic = msgSnapshot.value as? [String:AnyObject] else {
                    return
                }
                
                self.messages.append(Message(dictionary: dic))
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    let indexpath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexpath, at: .bottom, animated: true)
                }
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
    }
    
    
    // MARK : Upload Image
    
    func handleUploadImage()
    {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
        
    }

    func uploadImageToFirebase(image:UIImage)
    {
        let imageName = NSUUID().uuidString
        let ref = FIRStorage.storage().reference().child("message-images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2)
        {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil
                {
                    print("FC:Image Upload Error");
                    return
                }
                
                if let downloadUrl = metadata?.downloadURL()?.absoluteString
                {
                    let size = CGSize(width: image.size.width, height: image.size.height)
                    self.sendMessageWithImageUrl(imageUrl: downloadUrl,size:size )
                }
            })
            
        }
        
    }
    
    // Message Send / Handling
    
    func sendMessage()
    {
        inputTextField.resignFirstResponder()
        
        if  (inputTextField.text?.replacingOccurrences(of: " ", with: "").characters.count)! >  0
        {
            let properties:[String:AnyObject] = ["text":inputTextField.text as AnyObject]
            sendMessagewithProperties(properties: properties)
            inputTextField.text = nil
        }
    }
    
    
    func sendMessageWithImageUrl(imageUrl:String ,size:CGSize)
    {
        
        let properties:[String:AnyObject] = ["imageURL":imageUrl as AnyObject ,
                                       "imageWidth":size.width as AnyObject,
                                       "imageHeight":size.height as AnyObject
        ]

        sendMessagewithProperties(properties: properties)
    }
    
    
    func sendMessagewithProperties(properties:[String:AnyObject]){
        
            let toID = recipient?.id
            let fromID = FIRAuth.auth()?.currentUser?.uid
            let reference = FIRDatabase.database().reference().child("messages")
            let childReference = reference.childByAutoId()

            let timestamp:NSNumber  = NSNumber(value: NSDate.timeIntervalSinceReferenceDate)
            var values:[String:Any] = [
                                       "toId":toID,
                                       "fromId":fromID,
                                       "timestamp":timestamp ]
        
        properties.forEach { values[$0] = $1  }
            
            // childReference.updateChildValues(values)
            childReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
                
                if error != nil
                {
                    print("FC:Error in Sending messages")
                    return
                }
                
                let timelineReference = FIRDatabase.database().reference().child("timeline").child(fromID!).child(toID!)
                
                // update message in parent message node as well... (Fan out)
                
                let messageID = childReference.key
                timelineReference.updateChildValues([messageID: 1])
                
                let recipientUserRef = FIRDatabase.database().reference().child("timeline").child(toID!).child(fromID!)
                recipientUserRef.updateChildValues([messageID:1])
            })
    
    }
    
    
    // MARK : - CollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        configureMessagecell(cell: cell, message: message)
        // Text Message
        if let msgText = message.text
        {
             cell.bubbleWidthAnchor?.constant = getBoundingRectForText(text: msgText).width + 32
        }
            
         // Image Message
        else if message.imageURL != nil
        {
            cell.bubbleWidthAnchor?.constant = 200
          
        }
       
        return cell
    }
    
    func configureMessagecell(cell:ChatMessageCell , message:Message)
    {
        
        if let messageImageUrl = message.imageURL
        {
            cell.messageImageView.isHidden = false
            cell.messageImageView.loadCachedImageWith(url: messageImageUrl)
            cell.bubbleView.backgroundColor = UIColor.clear
            cell.textView.isHidden = true
            cell.delegate = self
            
        }
        else
        {
            cell.messageImageView.isHidden = true
            cell.textView.isHidden = false
        }
        
        if message.fromId == FIRAuth.auth()?.currentUser?.uid
        {
            // Out going msg
            
            cell.bubbleView.backgroundColor = AppTheme.kChatBubbleBlueColor
            cell.profileImageView.isHidden = true
        }
        else
        {
            // Incomming msg
            if let profileImg = self.recipient?.profileImageURL
            {
                cell.profileImageView.loadCachedImageWith(url: profileImg)
            }
            cell.bubbleView.backgroundColor = AppTheme.kChatBubbleGrayColor
            cell.textView.textColor = UIColor.black
            cell.bubbleLeftAnchor?.isActive = true
            cell.bubbleRightAnchor?.isActive = false
            cell.profileImageView.isHidden = false
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // Zooming
    
    var startingFrame:CGRect?
    var imageBackgroundView: UIView?
    var startingImageView:UIImageView?
    
    func performZoomingForStartingImage(image: UIImageView) {
        
        self.startingImageView = image
        startingImageView?.isHidden = true
        
         startingFrame = image.superview?.convert(image.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = image.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(gesuture:))))
        if let keyWindow =  UIApplication.shared.keyWindow
        {
             imageBackgroundView = UIView(frame: keyWindow.frame)
            imageBackgroundView?.backgroundColor = UIColor.black
            imageBackgroundView?.alpha = 0
            
            keyWindow.addSubview(imageBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            let height = (startingFrame!.height / startingFrame!.width) * keyWindow.frame.width
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.imageBackgroundView?.alpha = 1
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height:height)
                
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    // This is zoom image back to its origin position and remove background view from the key window
    
    func handleZoomOut(gesuture:UITapGestureRecognizer)
    {
     if  let zoomedImageView = gesuture.view as? UIImageView
     {
        startingImageView?.layer.cornerRadius = 16
        startingImageView?.layer.masksToBounds = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            zoomedImageView.frame = self.startingFrame!
            self.imageBackgroundView?.alpha = 0
            
        }, completion: { (completed) in
            zoomedImageView.removeFromSuperview()
            self.startingImageView?.isHidden = false
        })
    
     }
    }
}

extension ChatLogController:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.item]
        var height:CGFloat = 80

        if let text = message.text
        {
            height = getBoundingRectForText(text:text).height + 20

        }
        else if let cellWidth = message.imageWidth?.floatValue, let cellHeight = message.imageHeight?.floatValue
        {
            height = CGFloat((cellHeight/cellWidth) * 200)
        }
        
        let boundsWidth = UIScreen.main.bounds.size.width
        return CGSize(width: boundsWidth, height: height)
    }
    
    
     func getBoundingRectForText(text:String)->CGRect
     {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return   NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16 )], context: nil)
        
    }
}

extension ChatLogController:UIImagePickerControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
     
        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL
        {
          handleSelectedVideoForURL(videoURL: videoURL)
        }
        else
        {
            handleImageSelectedFor(info: info)
        }
        
      
    }
    
    private func handleImageSelectedFor(info:[String:Any])
    {
        var selectedImage:UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            selectedImage = editedImage
        }
        else if let  originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            selectedImage = originalImage
        }
        
        if let selectedImageFromPicker = selectedImage
        {
            uploadImageToFirebase(image: selectedImageFromPicker)
        }
        
        dismiss(animated: true, completion: nil)

    }

    
    private func handleSelectedVideoForURL(videoURL:URL)
    {
        let fileName = NSUUID().uuidString
        let reference  = FIRStorage.storage().reference().child("user-videos").child("\(videoURL).mp4")
       let uploadTask = reference.putFile(videoURL, metadata: nil, completion: { (metadata, error) in
            
            if error != nil
            {
                print("FC:Error Uploading video")
            }
            
            if let storageURL = metadata?.downloadURL()?.absoluteString
            {
                
            }
            
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnit = snapshot.progress?.completedUnitCount
            {
                    self.navigationItem.title = String(completedUnit)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.recipient?.name
        }
        
    }
}

