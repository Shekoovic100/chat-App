//
//  OutgoingMessages.swift
//  Kalmnychat
//
//  Created by Sherif samy on 3/11/21.
//  Copyright © 2021 Sherif samy. All rights reserved.
//

import Foundation


class OutgoingMessages{
    
    let messagesDictionary:NSMutableDictionary
    
    //MARK:- initilizers
    
    // for text Message : -
    
    init(message:String,senderId:String,senderName:String,date:Date
        ,messgeType:String,type:String,messageId:String){
        
        messagesDictionary = NSMutableDictionary(objects: [message,senderId,senderName,dateFormatter().string(from: date),messgeType,type,messageId], forKeys: [kMESSAGE as NSCopying,kSENDERID as NSCopying,kSENDERNAME as NSCopying,kDATE as NSCopying,kMESSAGETYPE as NSCopying,kTYPE as NSCopying,kMESSAGEID as NSCopying])
    }
    
    
    
    // for picture Messages :-
    
    
    init(message:String,senderId:String,senderName:String,date:Date
        ,messageType:String,imageLink:String,type:String,messageId:String){
        
        
        messagesDictionary = NSMutableDictionary(objects: [message,senderId,senderName
            ,dateFormatter().string(from: date),messageType,imageLink,type,messageId],
        forKeys: [kMESSAGE as NSCopying,kSENDERID as NSCopying
        ,kSENDERNAME as NSCopying,kDATE as NSCopying , kMESSAGETYPE as NSCopying ,kPICTURE as NSCopying,kTYPE as NSCopying,kMESSAGEID as NSCopying ])
        
    }
    
// Send message func  : -
    
    func sendMessage(chatroomId :String , messageDictionary:NSMutableDictionary ,membersIds:[String]){
        
        let DB = DBref.child(reference(.Message))
        
        for memberId in membersIds {

            //craete new reference for message in firebase :
            
            DB.child(memberId).child(chatroomId).child(messageDictionary[kMESSAGEID] as! String).setValue(messageDictionary as! [String:Any])
        }
        
    }
    
}
