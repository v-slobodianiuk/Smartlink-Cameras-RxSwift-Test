//
//  AppCoordinator.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import RxSwift
import UIKit

final class AppCoordinator: BaseCoordinator<Void> {
    
    fileprivate let dependencies: AppDependency
    fileprivate let window: UIWindow
    
    init(window: UIWindow) {
        self.dependencies = AppDependency()
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        coordinateToRoot(with: dependencies.userService.authenticationState.value)
        return Observable.never()
    }
    
    fileprivate func coordinateToRoot(with authenticationState: AuthenticationState) {
        switch authenticationState {
            case .signedIn:
                return showMainView()
                    .asDriverOnErrorJustComplete()
                    .drive(onNext: { [weak self] authState in
                        self?.coordinateToRoot(with: authState)
                    })
                    .disposed(by: disposeBag)
            
            case .signedOut:
                return showLoginView()
                    .asDriverOnErrorJustComplete()
                    .drive(onNext: { [weak self] authState in
                        self?.coordinateToRoot(with: authState)
                    })
                    .disposed(by: disposeBag)
        }
    }
    
    fileprivate func showLoginView() -> Observable<AuthenticationState> {
        let loginCoordinator = LoginCoordinator(dependencies: dependencies, window: window)
        return coordinate(to: loginCoordinator)
            .map({ [weak self] _ in self?.dependencies.userService.authenticationState.value ?? .signedOut })
    }

    fileprivate func showMainView() -> Observable<AuthenticationState> {
        let mainCoordinator = MainCoordinator(dependencies: dependencies, window: window)
        return coordinate(to: mainCoordinator)
            .map({ [weak self] _ in self?.dependencies.userService.authenticationState.value ?? .signedOut })
    }
    
}
