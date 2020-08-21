//
//  APIService.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation
import RxSwift

//MARK: - Server Errors
struct ServerErrorsModel: Codable {
    let error: String
}

enum ApiError: Error {
    case HttpResponseIsNil
    case DataIsNil
    case ServerError
}

//MARK: - API Service
protocol APIServiceProtocol {
    func send<T: Codable, E: Codable>(url: URL, httpMethod: String?, postModel: T?) -> Observable<E>
}

final class APIService: APIServiceProtocol {
    
    init() {
        
    }
    
    func send<T: Codable, E: Codable>(url: URL, httpMethod: String?, postModel: T?) -> Observable<E> {
        
        return Observable<E>.create { observer in
            let url = url
            var request = URLRequest(url: url)
            if httpMethod != nil {
                request.httpMethod = httpMethod
            }
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encodedData = JsonServise.shared.jsonEncode(model: postModel)
            request.httpBody = encodedData
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(ApiError.HttpResponseIsNil)
                    return
                }
                
                if let error = error {
                    observer.onError(error)
                }
                
                guard let safeData = data else {
                    observer.onError(ApiError.DataIsNil)
                    return
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    let model: E? = JsonServise.shared.jsonDecode(data: safeData)
                    guard let safeModel = model else { return }
                    observer.onNext(safeModel)
                case 400..<500:
                    let model: ServerErrorsModel? = JsonServise.shared.jsonDecode(data: safeData)
                    guard let safeModel = model else { return }
                    print(safeModel.error)
                case 500..<600:
                    observer.onError(ApiError.ServerError)
                default:
                    print("Status Code: ", httpResponse.statusCode)
                    print(String(data: safeData, encoding: .utf8) ?? "Couldn't decode Data")
                }
                
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    deinit {
        
    }
    
}
