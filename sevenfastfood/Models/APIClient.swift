//
//  APIClient.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import Foundation
import Alamofire

struct ResponseError: Decodable {
    let message: String?
}
class Interceptor: RequestInterceptor {
    private lazy var localDataModel = LocalData()
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let accessToken = localDataModel.getAccessToken()
        if let token = accessToken {
            urlRequest.headers.add(.authorization(bearerToken: token))
        }
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
final class APIClient {
    fileprivate let baseUrl = "https://sevenfastfood-be.onrender.com"
    fileprivate var session: Session?
    fileprivate lazy var localDataModel: LocalData = {
        let client = LocalData()
        return client
    }()
    fileprivate lazy var headers: HTTPHeaders = {
        [
            "Accept": "application/json"
        ]
    }()
    
    public static let shared = APIClient()
    init() {
        setupBasicSession()
    }
    
    func setupBasicSession() {
        let interceptor = Interceptor()
        let cacher = ResponseCacher(behavior: .cache)
        let monitor = ClosureEventMonitor()
        monitor.dataTaskDidReceiveData = {
            (request, task, data) in
            debugPrint("Done task: \(task) with data: \(data)")
        }
        monitor.requestDidCompleteTaskWithError = {
            (request, task, error) in
            debugPrint("Task: \(task) completed with error: \(error)")
        }
        session = Session(interceptor: interceptor, cachedResponseHandler: cacher, eventMonitors: [monitor])
    }
    
    
    func performGet<T: Codable>(withResponseType type: T.Type, withSubpath subpath: String, withParams params: Parameters?, completion: @escaping (Result<T?, Error>) -> Void) {
        guard let session = session else {
            return
        }
        session.request("\(baseUrl)\(subpath)", method: .get, parameters: params, headers: headers).responseJSON {
            response in
            
            guard let httpResponse = response.response,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = response.response?.statusCode ?? -1
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ResponseError.self, from: response.data!)
                    let errorMessage = response.message ?? "API request failed with status code \(statusCode)"
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
                return
            }
            
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(type.self, from: response.data!)
                    completion(.success(response))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: response.response?.statusCode ?? 100, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func performPost<T: Codable>(withResponseType type: T.Type, withSubpath subpath: String, withParams params: Parameters?, completion: @escaping (Result<T?, Error>) -> Void) {
        guard let session = session else {
            return
        }
        session.request("\(baseUrl)\(subpath)", method: .post, parameters: params, headers: headers).responseJSON {
            response in
            
            guard let httpResponse = response.response,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = response.response?.statusCode ?? -1
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ResponseError.self, from: response.data!)
                    let errorMessage = response.message ?? "API request failed with status code \(statusCode)"
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
                return
            }
            
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(type.self, from: response.data!)
                    completion(.success(response))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: response.response?.statusCode ?? 100, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func performPut<T: Codable>(withResponseType type: T.Type, withSubpath subpath: String, withParams params: Parameters?, completion: @escaping (Result<T?, Error>) -> Void) {
        guard let session = session else {
            return
        }
        session.request("\(baseUrl)\(subpath)", method: .put, parameters: params, headers: headers).responseJSON {
            response in
            
            guard let httpResponse = response.response,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = response.response?.statusCode ?? -1
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ResponseError.self, from: response.data!)
                    let errorMessage = response.message ?? "API request failed with status code \(statusCode)"
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
                return
            }

            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(type.self, from: response.data!)
                    completion(.success(response))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: response.response?.statusCode ?? 100, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func performPatch<T: Codable>(withResponseType type: T.Type, withSubpath subpath: String, withParams params: Parameters?, completion: @escaping (Result<T?, Error>) -> Void) {
        guard let session = session else {
            return
        }
        session.request("\(baseUrl)\(subpath)", method: .patch, parameters: params, headers: headers).responseJSON {
            response in
            
            guard let httpResponse = response.response,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = response.response?.statusCode ?? -1
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ResponseError.self, from: response.data!)
                    let errorMessage = response.message ?? "API request failed with status code \(statusCode)"
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
                return
            }

            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(type.self, from: response.data!)
                    completion(.success(response))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: response.response?.statusCode ?? 100, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func performDelete<T: Codable>(withResponseType type: T.Type, withSubpath subpath: String, withParams params: Parameters?, completion: @escaping (Result<T?, Error>) -> Void) {
        guard let session = session else {
            return
        }
        session.request("\(baseUrl)\(subpath)", method: .delete, parameters: params, headers: headers).responseJSON {
            response in
            
            guard let httpResponse = response.response,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = response.response?.statusCode ?? -1
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ResponseError.self, from: response.data!)
                    let errorMessage = response.message ?? "API request failed with status code \(statusCode)"
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
                return
            }

            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(type.self, from: response.data!)
                    completion(.success(response))
                } catch {
                    completion(.failure(NSError(domain: "APIHandler", code: response.response?.statusCode ?? 100, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
