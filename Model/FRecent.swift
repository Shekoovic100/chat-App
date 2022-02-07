//
//  FRecent.swift
//  MyChatTest
//
//  Created by Mohamed Arafa on 3/15/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit

class RecentType{

    var avatarStr: String
    var chatRoomID: String
    var email: String
    var createdAt: Date
    var updatedAt: Date
    var lastMessage: String
    var type: String
    var withUserFullName: String
    var objectId: String
    var members: [String]
    
    
    init(avatarStr: String, chatRoomID: String, email: String, createdAt: Date , updatedAt: Date, lastMessage: String, type: String, withUserFullName: String, objectId: String, members: [String] ) {
        
        self.avatarStr = avatarStr
        self.chatRoomID = chatRoomID
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastMessage = lastMessage
        self.type = type
        self.withUserFullName = withUserFullName
        self.objectId = objectId
        self.members = members
        
    }
    
    
    
    init(_dictionary: NSDictionary) {

        objectId = _dictionary[kOBJECTID] as! String
        
        if let created = _dictionary[kCREATEDAT] {
            if (created as! String).count != 14 {
                createdAt = Date()
            } else {
                createdAt = dateFormatter().date(from: created as! String)!
            }
        } else {
            createdAt = Date()
        }

        if let updateded = _dictionary[kUPDATEDAT] {
            if (updateded as! String).count != 14 {
                updatedAt = Date()
            } else {
                updatedAt = dateFormatter().date(from: updateded as! String)!
            }
        } else {
            updatedAt = Date()
        }

        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }

        if let roomID = _dictionary[kCHATROOMID] {
            chatRoomID = roomID as! String
        } else {
            chatRoomID = ""
        }

        if let myAvatar = _dictionary[kAVATAR] {
            avatarStr = myAvatar as! String
        } else {
            avatarStr = ""
        }
        
        if let lastMesg = _dictionary[kLASTMESSAGE] {
            lastMessage = lastMesg as! String
        } else {
            lastMessage = ""
        }
        
        if let Type = _dictionary[kTYPE] {
            type = Type as! String
        } else {
            type = ""
        }
        
        if let ufName = _dictionary[kWITHUSERFULLNAME] {
            withUserFullName = ufName as! String
        } else {
            withUserFullName = ""
        }

        if let membr = _dictionary[kMEMBERS] {
            members = membr as! [String]
        } else {
            members = [""]
        }

    }
    
}


func recentDictionaryFrom(recent: RecentType) -> NSDictionary {
    
    let createdAt = dateFormatter().string(from: recent.createdAt)
    let updatedAt = dateFormatter().string(from: recent.updatedAt)
    
    return NSDictionary(objects: [recent.avatarStr, recent.chatRoomID, createdAt, recent.email, recent.lastMessage, recent.members, updatedAt, recent.type,  recent.withUserFullName, recent.objectId], forKeys: [kAVATAR as NSCopying, kCHATROOMID as NSCopying, kCREATEDAT as NSCopying, kEMAIL as NSCopying, kLASTMESSAGE as NSCopying, kMEMBERS as NSCopying, kUPDATEDAT as NSCopying, kTYPE as NSCopying, kWITHUSERFULLNAME as NSCopying, kOBJECTID as NSCopying])
}
