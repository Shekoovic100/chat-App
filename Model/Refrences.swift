//
//  Refrences.swift
//  MyChatTest
//
//  Created by Mohamed Arafa on 3/9/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import Foundation
import Firebase

enum FReference: String {
    
    case User
    case Recent
    case Message
}


func reference(_ collectionReference: FReference) -> String{
    return collectionReference.rawValue
}
