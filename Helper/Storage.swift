//
//  Storage.swift
//  Kalmnychat
//
//  Created by Sherif samy on 3/15/21.
//  Copyright © 2021 Sherif samy. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import MBProgressHUD


let storage = Storage.storage()
let kFILEREFERENCE = "gs://chatapp-c1c69.appspot.com"


//MARK:- upload Image :-

func uploadImage(image:UIImage , chatRoomId :String,view :UIView,completion : @escaping (_ imageLink :String?)-> Void){
    
    let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    progressHUD.mode = .determinateHorizontalBar
    
    let dateString = dateFormatter().string(from: Date())
    
    let photoFileName = "pictureMessage" + FUser.currentId() + "/" + chatRoomId + "/" + dateString + "jpg"
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(photoFileName)
    let imageData = image.jpegData(compressionQuality: 0.4)
    
    var task :StorageUploadTask!
    
    task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
        task.removeAllObservers()
        progressHUD.hide(animated: true)
        
        if error != nil {
            print("Errror uploading data \(error!.localizedDescription)")
            return
        }
        storageRef.downloadURL { (url, error) in
            
            guard let imageURL = url else{
                completion(nil)
                return
            }
            
            completion(imageURL.absoluteString)
        }
        
    })
    
    task.observe(StorageTaskStatus.progress){(snapshot) in
        
        progressHUD.progress = Float((snapshot.progress?.completedUnitCount)!) / Float ((snapshot.progress?.totalUnitCount)!)
    }
}




//MARK:- file path and if exist documents :


func getDocumentsURL() -> URL{
    
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    
    return documentURL!
    
}


func fileInDocumentsDirectory(fileName : String) -> String{
    
    let fileURL = getDocumentsURL().appendingPathComponent(fileName)
    return fileURL.path
    
}


func fileExistsAtPath(path : String) -> Bool{
    
    var doesExist = false
    
    
    let filePath = fileInDocumentsDirectory(fileName: path)
    let fileManger = FileManager.default
    
    if fileManger.fileExists(atPath: filePath){
        
        doesExist = true
    }else{
        
        doesExist = false
    }
    
    return doesExist
}

//MARK:- Download image

func downloadImage(imageUrl: String,completion: @escaping (_ image: UIImage?)-> Void){
    
    let imageURL = NSURL(string: imageUrl)
    let imageFileName = (imageUrl.components(separatedBy: "%").last!).components(separatedBy: "?").first!
    
    if fileExistsAtPath(path: imageFileName){
        
        //exist
        
        if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)){
            completion(contentsOfFile)
        }else{
            print("couldnot generate image ")
            completion(nil)
        }
           
    }else{
        
        //doesn't exist
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        downloadQueue.async {
            
            let data = NSData(contentsOf: imageURL! as URL)
            if data != nil {
                var fileManagerURL = getDocumentsURL()
                
                fileManagerURL = fileManagerURL.appendingPathComponent(imageFileName,isDirectory: false)
                data!.write(to: fileManagerURL, atomically: true)
                let imageToReturn = UIImage(data: data! as Data)
                
                DispatchQueue.main.async {
                    completion(imageToReturn!)
                }
            }else{
                DispatchQueue.main.async {
                    print("no image in database")
                    completion(nil)
                }
            }
        }
    }
}
