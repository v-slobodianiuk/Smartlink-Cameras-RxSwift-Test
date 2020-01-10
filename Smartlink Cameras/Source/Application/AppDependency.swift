//
//  AppDependency.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation

protocol HasAPIService {
    var apiService: APIServiceProtocol { get }
}

protocol HasUserService {
    var userService: UserServiceProtocol { get }
}

struct AppDependency: HasAPIService, HasUserService {
    
    let apiService: APIServiceProtocol
    let userService: UserServiceProtocol
    
    init() {
        apiService = APIService()
        userService = UserService(apiService: apiService)
    }
    
}
