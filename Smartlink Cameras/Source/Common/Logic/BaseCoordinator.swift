//
//  BaseCoordinator.swift
//  Smartlink
//
//  Created by Minhaz Mohammad on 11/28/18.
//  Copyright © 2018 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation
import RxSwift

protocol CoordinatorType {
    associatedtype CoordinationResult
    
    var identifier: UUID { get }
    
    func start() -> Observable<CoordinationResult>
}

// MARK: - Base abstract coordinator generic over the return type of the `start` method.
class BaseCoordinator<ResultType>: CoordinatorType {
    
    // MARK: - Typealias which allows to access a ResultType of the Coordainator by `CoordinatorName.CoordinationResult`.
    typealias CoordinationResult = ResultType
    
    // MARK: - Utility `DisposeBag` used by the subclasses.
    let disposeBag = DisposeBag()
    
    // MARK: - Unique identifier.
    let identifier = UUID()
    
    // MARK: - Dictionary of the child coordinators. Every child coordinator should be added
    //         to that dictionary in order to keep it in memory.
    //         Key is an `identifier` of the child coordinator and value is the coordinator itself.
    //         Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()
    
    // MARK: - Stores coordinator to the `childCoordinators` dictionary.
    //
    //       - Parameter coordinator: Child coordinator to store.
    private func store<T: CoordinatorType>(coordinator: T) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    // MARK: - Release coordinator from the `childCoordinators` dictionary.
    //
    //       - Parameter coordinator: Coordinator to release.
    private func free<T: CoordinatorType>(coordinator: T) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    // MARK: - Exp:
    //         1. Stores coordinator in a dictionary of child coordinators.
    //         2. Calls method `start()` on that coordinator.
    //         3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    //
    //       - Parameter coordinator: Coordinator to start.
    //       - Returns: Result of `start()` method.
    func coordinate<T: CoordinatorType, U>(to coordinator: T) -> Observable<U> where U == T.CoordinationResult {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }
    
    // MARK: - Starts job of the coordinator.
    //
    //       - Returns: Result of coordinator job.
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
    
}
