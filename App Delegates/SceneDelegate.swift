//
//  SceneDelegate.swift
//  Kalmnychat
//
//  Created by Sherif samy on 2/28/21.
//  Copyright © 2021 Sherif samy. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
// check if Userdefaults  data is exist to open app directly and dont need to sign in when i want use app : -
        
        if  UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
            
            let rootVc = UIStoryboard(name: "Users", bundle: nil).instantiateViewController(identifier: "myUserNav")
            
            self.window?.rootViewController = rootVc
        }

        guard let _ = (scene as? UIWindowScene) else { return }
    }

  

}

