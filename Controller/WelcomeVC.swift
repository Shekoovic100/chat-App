//
//  ViewController.swift
//  Kalmnychat
//
//  Created by Sherif samy on 2/28/21.
//  Copyright © 2021 Sherif samy. All rights reserved.
//

import UIKit
import ImagePicker
import Firebase
import ProgressHUD

class WelcomeVC: UIViewController {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTF: UITextField!{
        didSet{
            
            nameTF.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor :UIColor.white.withAlphaComponent(0.5)])
        }
        
    }
    @IBOutlet weak var emailTF: UITextField!{
        didSet{
            emailTF.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var passswordTF: UITextField!{
        didSet{
            passswordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        }
    }
    
    @IBOutlet weak var signOutlet: UIButton!{
        
        didSet{
            signOutlet.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var logNotfiicationLbl: UILabel!
    
    
    //MARK:- Contants :
    
    let leftSwipGes = UISwipeGestureRecognizer()
    let rightSwipeGes = UISwipeGestureRecognizer()
    var profileImage: UIImage?
    let imageTapped =  UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwips()
        ProfileImageTapped()
    }
    
    
    
    
    
    //MARK:- IbActions
    
    @objc func Swipped(){
        
        if signOutlet.titleLabel?.text == "Sign Up"{
            
            signOutlet.setTitle("Sign in ", for: .normal)
            nameTF.isHidden = true
            profileImageView.isHidden = true
            logNotfiicationLbl.text = "Swip to Sign up"
            
        }else{
            
            signOutlet.setTitle("Sign Up", for: .normal)
            nameTF.isHidden = false
            profileImageView.isHidden = false
            logNotfiicationLbl.text = "Swip to sign in "
        }
    }
    
    
    @IBAction func signBtnPressed(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Sign Up"{
            
            registerBtnPressed()
            
        }else {
            
            loginBtnPressed()
        }
    }
    
    @objc func imagePressed(){
        
        let imagePickerView = ImagePickerController()
        imagePickerView.imageLimit = 1
        imagePickerView.delegate = self
        self.present(imagePickerView, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Helper Functions :-
    
    func setSwips(){
        
        leftSwipGes.direction = .left
        rightSwipeGes.direction = .right
        
        self.view.addGestureRecognizer(leftSwipGes)
        self.view.addGestureRecognizer(rightSwipeGes)
        
        leftSwipGes.addTarget(self, action: #selector(self.Swipped))
        rightSwipeGes.addTarget(self, action: #selector(self.Swipped))
    }
    
    func ProfileImageTapped(){
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTapped)
        imageTapped.addTarget(self, action: #selector(self.imagePressed))
    }
    
    
    func loginBtnPressed(){
        
        guard !emailTF.text!.isEmpty,
            !passswordTF.text!.isEmpty else{return}
        Auth.auth().signIn(withEmail: emailTF.text!, password: passswordTF.text!) { (result, error) in
            
            if error != nil {
                
                ProgressHUD.showError(error!.localizedDescription)
                print(error!.localizedDescription)
                return
            }
            
            print(result!.user.uid)
            SaveCurrentUser(uId: result!.user.uid) {(isSaved) in
                
                if isSaved{
                    
                    //TODO:- go to home screen
                    self.goToHome()
                    
                }else{
                     
                    ProgressHUD.showError("User Not Saved ")
                }
            }
              
        }
    }
    
    func registerBtnPressed(){
        
        
        guard !emailTF.text!.isEmpty,
            !passswordTF.text!.isEmpty,
            !nameTF.text!.isEmpty,profileImage != nil
            else{ ProgressHUD.showError("Fill empty Fields");  return}
        
        Auth.auth().createUser(withEmail: emailTF.text!, password: passswordTF.text!)
        { (result, error) in
            
            if error != nil {
                
                ProgressHUD.showError(error!.localizedDescription)
                print(error!.localizedDescription)
                return
            }
            
            print(result!.user.uid)
           
            self.saveUserToDatabase(uID: result!.user.uid)
        }
        
    }
    
    func saveUserToDatabase(uID:String){
        
  // (1) convert user from objects to dicitionary :
        
        let fUser = FUser(_objectId: uID, _createdAt: Date(), _updatedAt: Date(), _email: emailTF.text!, _fullname: nameTF.text!, _avatar: stringFromImage(image: profileImage!))
        
   // (2) put user after conversion to my specific fun that pass value to dic form:
        
         let userDic = userDictionaryFrom(user: fUser)
        
        //(3) add to data pase use Fb steps :-
        
        DBref.child(reference(.User)).child(uID).setValue(userDic) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            print("User Saved successfully")
            
            saveUserLocally(fUser: fUser)
            
            //TODO:-  go to home screen
            
            self.goToHome()
        }
    }

    
    func goToHome(){
        
        
        let vc = UIStoryboard(name: "Users", bundle: nil).instantiateViewController(identifier: "myUserNav")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    
   
}

extension WelcomeVC : ImagePickerDelegate{
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if images.count > 0{
            
            profileImage = images.first
            profileImageView.image = profileImage!.circleMasked
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
