//
//  LoginViewModel.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation
import RxSwift

final class LoginViewModel: ViewModelProtocol {
    
    typealias Dependency = HasUserService
    
    struct Bindings {
        let loginButtonTap: Observable<Void>
    }
    
    let loginResult: Observable<Void>
    
    init(dependency: Dependency, bindings: Bindings) {
        loginResult = bindings.loginButtonTap
            .do(onNext: { _ in dependency.userService.login()  })
    }
    
    deinit {
        
    }
    
}
