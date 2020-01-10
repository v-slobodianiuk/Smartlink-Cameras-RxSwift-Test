//
//  RxSwift+Extensions.swift
//  Smartlink
//
//  Created by Minhaz Mohammad on 8/13/18.
//  Copyright © 2018 SecureNet Technologies, LLC. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map({ _ in })
    }
    
}
