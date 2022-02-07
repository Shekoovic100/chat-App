//
//  FMessageType.swift
//  MyChatTest
//
//  Created by Mohamed Arafa on 3/15/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import Foundation

enum FMessageType: String {
    
    case text
    case image
    case location
    case audio
    case video
}

func messageType(_ type: FMessageType) -> String{
    return type.rawValue
}
