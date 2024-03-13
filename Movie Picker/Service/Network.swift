//
//  Network.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation
import Alamofire

class Network {
    
    // MARK: - Properties
    
    static let mainService = Network()
    public typealias ThrowableGenericResponse<T: Codable> = (() throws -> (T?)) -> Void
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Service
    
    func getRequest<T: Codable>(to url: String, parameters: Parameters?=nil, headers: HTTPHeaders?=nil, method: HTTPMethod = .get, expectedReturnType: T.Type, completion: @escaping ThrowableGenericResponse<T>) {
        AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self) { [weak self] response in
            self?.handleResponse(response: response, completion: completion)
        }
    }
    
    // MARK: - Helpers
    
    private func handleResponse<T : Codable>(response: DataResponse<T, AFError>, completion: @escaping ThrowableGenericResponse<T>) {
        switch response.result {
        case .success(let responseData):
            handleCompleteResponse(response: response, completion: completion)
        case .failure(let error):
            completion {
                throw CustomError.timeout
            }
        }
    }
    
    private func handleCompleteResponse<T : Codable>(response: DataResponse<T, AFError>, completion: ThrowableGenericResponse<T>) {
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200..<300:
                completion {
                    return response.value
                }
            default:
                completion {
                    throw CustomError.statusCode(statusCode)
                }
            }
        } else {
            completion {
                throw CustomError.statusCode(666)
            }
        }
    }
    
}
