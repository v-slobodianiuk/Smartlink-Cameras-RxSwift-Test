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
    
    private let url = URL(string: "http://registration.securenettech.com/registration.php")!
    fileprivate let disposeBag = DisposeBag()
    
    struct Bindings {
        let loginButtonTap: Observable<Void>
        let loginTextField: Observable<String?>
    }
    
    let loginResult: Observable<Void>
    
    init(dependency: Dependency, bindings: Bindings) {
        loginResult = bindings.loginButtonTap
            .do(onNext: { _ in dependency.userService.login()  })
        
        getData(dependency: dependency, bindings: bindings)

    }
    
    fileprivate func getData(dependency: Dependency, bindings: Bindings) {
        bindings.loginTextField
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .filter { $0 != "" }
            .map { LoginPostModel(method: "getPartnerEnvironment", username: $0 ?? "", environment: "PRODUCTION")}
            .flatMap { [weak self] model -> Observable<LoginModel> in
                return dependency.userService.apiService.send(url: self!.url, httpMethod: "POST", postModel: model)
        }
        .subscribe( onNext: { model in
            print(model.platform.baseURL)
        })
        .disposed(by: disposeBag)
    }
    
    deinit {

    }
}
