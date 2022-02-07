//
//  Security.swift
//  MyChatTest


import Foundation
import RNCryptor

class Encryption{
    
    class func encryptText(chatRoomId: String, message: String) -> String{
        
        let data = message.data(using: String.Encoding.utf8)
        let encryptedDate = RNCryptor.encrypt(data: data!, withPassword: chatRoomId)
        
        return encryptedDate.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    class func decryptText(chatRoomId: String, encryptedMessage: String) -> String{
        
        let decryptor = RNCryptor.Decryptor(password: chatRoomId)
        
        let encryptedDate = NSData(base64Encoded: encryptedMessage, options: NSData.Base64DecodingOptions(rawValue: 0))
        
        var message : NSString = ""
        
        if encryptedDate != nil{
            do{
                
                let decreptedData = try decryptor.decrypt(data: encryptedDate! as Data)
                
                message = NSString(data: decreptedData, encoding: String.Encoding.utf8.rawValue)!
                
            }catch{
                print("Error in encrypted data \(error)")
            }
        }
        
        return message as String
    }
}
