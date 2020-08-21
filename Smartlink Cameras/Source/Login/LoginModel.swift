//
//  LoginModel.swift
//  Smartlink Cameras
//
//  Created by Vadym on 20.08.2020.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation

struct LoginModel: Codable {
    let server: Server
    let platform: Platform
}

struct Platform: Codable {
    let baseURL: String
}

struct Server: Codable {
    let partner, environment: String
}

struct LoginPostModel: Codable {
    let method, username, environment: String
}
