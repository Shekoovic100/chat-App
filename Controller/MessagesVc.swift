//
//  MessagesVc.swift
//  Kalmnychat
//
//  Created by Sherif samy on 3/11/21.
//  Copyright © 2021 Sherif samy. All rights reserved.
//

import UIKit
import ImagePicker

class MessagesVc: UIViewController {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBodyTF: UITextField!
    @IBOutlet weak var senderBtnOutlet: UIButton!
    
    //MARK:- constants :
    
    var ChatRoomId :String!
    var usersId: [String]!
    var messages = [Messages]()
    var users = [FUser]()
    var selectedImage : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messages = []
        getMessages()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        // make height for cell depend on content for cell:- 
        tableView.rowHeight = UITableView.automaticDimension
        
        
        ChatRoomId = getChatRoomId(fUserId:usersId.first!, sUserId:usersId.last!)
        
    }
    
    //MARK:- IbActions:
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        if messageBodyTF.text != ""{
            senderBtnOutlet.isEnabled = false
            
            sendMyMessage(text: messageBodyTF.text!, photo: nil)
            
        }
    }
    
    
    
    @IBAction func imagePickerPressed(_ sender: UIButton) {
        
        let picker = ImagePickerController()
        picker.imageLimit = 1
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    
    //MARK:- Helper Functions : -
    
    func sendMyMessage(text:String?,photo:String?){
        
        if let text = text {
            
            let encryptedText = Encryption.encryptText(chatRoomId: ChatRoomId, message:text)
            let messageID = UUID().uuidString
            
            let goingMessage = OutgoingMessages(message: encryptedText, senderId:FUser.currentId(), senderName: FUser.currentUser()?.fullname ?? "", date: Date(), messgeType: kPRIVATE, type: messageType(.text), messageId: messageID)
            
            goingMessage.sendMessage(chatroomId: ChatRoomId, messageDictionary: goingMessage.messagesDictionary, membersIds: usersId)
            
            messageBodyTF.text = ""
            senderBtnOutlet.isEnabled = true
        }
        
        if let photo = photo {
            let encryptedText = Encryption.encryptText(chatRoomId: ChatRoomId, message:"[image]")

            let messageID = UUID().uuidString
            
            let goingMessage = OutgoingMessages(message: encryptedText, senderId: FUser.currentId(), senderName: FUser.currentUser()?.fullname ?? "", date: Date(), messageType: kPRIVATE, imageLink: photo, type: messageType(.image), messageId: messageID)
            
            goingMessage.sendMessage(chatroomId: ChatRoomId, messageDictionary: goingMessage.messagesDictionary, membersIds: usersId)
        }
        
    }
    
    func getMessages(){
        
        DBref.child(reference(.Message)).child(FUser.currentId()).child(ChatRoomId).queryOrdered(byChild: kDATE).observe(.childAdded) { (snapshot) in
            
            let snap = snapshot.value as! NSDictionary
            let newMessage = Messages(_dictionary: snap,chatRoomId: self.ChatRoomId)
            
            self.messages.append(newMessage)
            self.tableView.reloadData()
            self.scrollDown()
        }
    }
    
    ///function  to view last 2 messages at least  in tableview in app or (make last message appears clear):-
    
    func scrollDown(){
        DispatchQueue.main.async {
            
            let indexpath = IndexPath(row: self.messages.count - 1, section: 0)
            if (indexpath.row > 0){
                
                self.tableView.scrollToRow(at: indexpath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
        
    }
    
}

//MARK:- table View delegates :

extension MessagesVc :UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if messages[indexPath.row].type == kTEXT{
            
            if messages[indexPath.row].senderId == FUser.currentId(){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)as!myMessageTVCell
                cell.messageLBL.text = messages[indexPath.row].message
                cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
                
                return cell
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)as!myFriendsMessageTVC
                
                cell.messageLBL.text = messages[indexPath.row].message
                cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
                return cell
            }
            
        }else{
            if messages[indexPath.row].senderId == FUser.currentId(){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath)as!myImageTVCell
                
                    downloadImage(imageUrl: messages[indexPath.row].picture) { (myImage) in
                    if let myImage = myImage{
                        cell.cellImageview.image = myImage
                    }
                }
                cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
                
                return cell
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath)as!myFriendsImageTVCell
               
                downloadImage(imageUrl: messages[indexPath.row].picture) { (myImg) in
                    
                    if let myImg = myImg{
                        cell.cellImageView.image = myImg
                    }
                }
                cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
                return cell
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}
extension MessagesVc : ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count > 0 {
            
            selectedImage = images.last
            uploadImage (image: selectedImage!, chatRoomId: self.ChatRoomId, view: self.navigationController!.view) { (imageURL) in
                guard let imageURL = imageURL else {return}
                self.sendMyMessage(text: nil, photo: imageURL)
            }
            
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
