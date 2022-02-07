//
//  UsersVC.swift
//  Kalmnychat
//
//  Created by Sherif samy on 3/1/21.
//  Copyright © 2021 Sherif samy. All rights reserved.
//

import UIKit

class UsersVC: UIViewController {
    //MARK:- Outlets
    
    
    @IBOutlet weak var tableview: UITableView!
    
    

    //MARK:- constants

    var users = [FUser]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUsersData()
        
    }
    
    
    //MARK:- IBAction
    
    
    
    
    
    //MARK:- helper Function
    
    func getUsersData(){
        
        DBref.child(reference(.User)).observe(.value) { (snapshot) in
            
            let snap = snapshot.value as![String:Any]
            
            for (_,value) in snap{
     
                 let Fuser = FUser(_dictionary: value as! NSDictionary)
                
                if Fuser.objectId != FUser.currentId(){
                     self.users.append(Fuser)
                }
                
            }
            self.tableview.reloadData()
        }
        
       
    }
    
    
    
    
    
}
extension UsersVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as!usersCell
        cell.nameLbl.text = users[indexPath.row].fullname
        cell.emailLbl.text = users[indexPath.row].email
        
        imageFromString(pictureData: users[indexPath.row].avatar) { (Img) in
            
            guard let myImg = Img else{return}
            
            cell.userimageView.image = myImg.circleMasked
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100 
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(identifier: "MessagesVc")as!
        MessagesVc
        vc.users = [FUser.currentUser()!,users[indexPath.row]]
        vc.usersId = [FUser.currentId(),users[indexPath.row].objectId]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
