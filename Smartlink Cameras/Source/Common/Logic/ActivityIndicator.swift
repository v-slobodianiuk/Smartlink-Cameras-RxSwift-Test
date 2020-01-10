//
//  ActivityIndicator.swift
//  Smartlink
//
//  Created by Minhaz Mohammad on 10/19/18.
//  Copyright © 2018 SecureNet Technologies, LLC. All rights reserved.
//

import RxSwift
import RxCocoa

private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

/**
 Enables monitoring of sequence computation.
 
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
final class ActivityIndicator: SharedSequenceConvertibleType {
    
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    init() {
        _loading = _relay.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element> {
        return source.asObservable()
            .do(onNext: { [weak self] _ in
                self?.decrement()
            }, onError: { [weak self] _ in
                self?.decrement()
            }, onCompleted: { [weak self] in
                self?.decrement()
            }, onSubscribe: increment)
        
//        return Observable.using({ () -> ActivityToken<Source.Element> in
//            self.increment()
//            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
//        }) { t in
//            return t.asObservable()
//        }
    }
    
    fileprivate func increment() {
        _lock.lock()
        _relay.accept(_relay.value + 1)
        _lock.unlock()
    }
    
    fileprivate func decrement() {
        _lock.lock()
        _relay.accept(_relay.value - 1)
        _lock.unlock()
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
}

extension ObservableConvertibleType {
    
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
    
}
