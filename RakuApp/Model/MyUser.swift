//
//  MyUser.swift
//  RakuApp
//
//  Created by Surya on 21/05/25.
//

import Foundation

struct MyUser: Identifiable, Hashable, Codable{
    var id: String = ""
    var email: String = ""
    var name: String = ""
    var password: String = ""
    var experience: String = "beginner"
}

