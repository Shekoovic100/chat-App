//
//  HelperFunctions.swift
//  MyChatTest
//
//  Created by Mohamed Arafa on 3/9/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit
import FirebaseFirestore

//MARK: GLOBAL FUNCTIONS
private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}

 
 
func timeElapsed(date: Date) -> String {
    
    let seconds = NSDate().timeIntervalSince(date)
    
    var elapsed: String?
    
    
    if (seconds < 60) {
        elapsed = "Just now"
    } else if (seconds < 60 * 60) {
        let minutes = Int(seconds / 60)
        
        var minText = "min"
        if minutes > 1 {
            minText = "mins"
        }
        elapsed = "\(minutes) \(minText)"
        
    } else if (seconds < 24 * 60 * 60) {
        let hours = Int(seconds / (60 * 60))
        var hourText = "hour"
        if hours > 1 {
            hourText = "hours"
        }
        elapsed = "\(hours) \(hourText)"
    } else {
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "yyyy-MM-dd"
        
        elapsed = "\(currentDateFormater.string(from: date))"
    }
    
    return elapsed!
}
/*//Time
func formatCallTime(date: Date) -> String {
    
    let seconds = NSDate().timeIntervalSince(date)
    
    var elapsed: String?
    
    
    if (seconds < 60) {
        elapsed = "Just now"
    }  else if (seconds < 24 * 60 * 60) {
       
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "HH:mm:ss"

        elapsed = "\(currentDateFormater.string(from: date))"
    } else {
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        elapsed = "\(currentDateFormater.string(from: date))"
    }
    
    return elapsed!
}

// read time status "HH:MM"

func readTimeFrom(dateString: String) -> String{
    
    let date = dateFormatter().date(from: dateString)
    
    let CurrentDateFormat = dateFormatter()
    CurrentDateFormat.dateFormat = "HH:mm:ss"
    
    return CurrentDateFormat.string(from: date!)
}
*/

func imageFromString(pictureData: String, withBlock: (_ image: UIImage?) -> Void) {
    
    var image: UIImage?
    
    let decodedData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    image = UIImage(data: decodedData! as Data)
    
    withBlock(image)
}

//for avatars
//func dataImageFromString(pictureString: String, withBlock: (_ image: Data?) -> Void) {
//
//    let imageData = NSData(base64Encoded: pictureString, options: NSData.Base64DecodingOptions(rawValue: 0))
//
//    withBlock(imageData as Data?)
//}



func stringFromImage(image:UIImage)-> String{
    
    
    let imageData = image.jpegData(compressionQuality: 0.5)
    
    guard let encodedString = imageData?
        .base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        else{return ""}
    
    return encodedString
}

func getChatRoomId(fUserId:String,sUserId:String)->String{
    
    let com = fUserId.compare(sUserId).rawValue
    
    
    if com > 0 {
        
        return fUserId + sUserId
        
    }else{
        
         return sUserId + fUserId
    }
}
