//
//  LoginCoordinator.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import RxSwift
import UIKit

final class LoginCoordinator: BaseCoordinator<Void> {
    
    typealias Dependencies = HasUserService
    
    fileprivate let dependencies: Dependencies
    fileprivate let window: UIWindow
    
    init(dependencies: Dependencies, window: UIWindow) {
        self.dependencies = dependencies
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewController = LoginViewController()
        
        window.setRootViewController(viewController)
        
        return Observable.never()
    }
    
    deinit {
        
    }
    
}
