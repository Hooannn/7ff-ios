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
class AuthenInterceptor: RequestInterceptor {
    private var headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    private let baseUrl = "https://sevenfastfood-be.onrender.com"
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let token = LocalData.shared.getAccessToken() {
            urlRequest.headers.add(.authorization(bearerToken: token))
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let statusCode = request.response?.statusCode
        if statusCode == 401 || statusCode == 403 {
            debugPrint("Trace: Get 401 or 403 status code. Try to refresh")
            guard let refreshToken = LocalData.shared.getRefreshToken() else {
                Toast.shared.display(with: "Your session has been expired")
                completion(.doNotRetry)
                return
            }
            self.refresh(with: refreshToken) {
                result in
                switch result {
                case.success(let token):
                    debugPrint("Refresh success \(token)")
                    LocalData.shared.setAccessToken(token)
                    completion(.retry)
                default: completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
    
    private func refresh(with refreshToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let params = [
            "refreshToken": refreshToken
        ]
        AF.request("\(baseUrl)/auth/refresh", method: .post, parameters: params, headers: headers).responseJSON {
            result in
            guard let httpResponse = result.response,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = result.response?.statusCode ?? -1
                completion(.failure(NSError(domain: "APIHandler", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Refresh failed"])))
                return
            }
            
            switch result.result {
            case .success(_):
                let json = try? JSONSerialization.jsonObject(with: result.data!) as? [String: Any]
                let data = json?["data"] as? [String: String]
                if let accessToken = data?["accessToken"] {
                    completion(.success(accessToken))
                } else {
                    completion(.failure(NSError(domain: "APIHandler", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Refresh failed"])))
                }
            default: completion(.failure(NSError(domain: "APIHandler", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Refresh failed"])))
            }
        }
    }
}
final class APIClient {
    private let baseUrl = "https://sevenfastfood-be.onrender.com"
    private var session: Session?

    private lazy var localDataModel: LocalData = {
        let client = LocalData()
        return client
    }()

    private lazy var headers: HTTPHeaders = {
        [
            "Accept": "application/json"
        ]
    }()
    
    public static let shared = APIClient()
    
    init() {
        setupBasicSession()
    }
    
    func setupBasicSession() {
        let interceptor = AuthenInterceptor()
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
        session.request("\(baseUrl)\(subpath)", method: .get, parameters: params, headers: headers).validate().responseJSON {
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
        session.request("\(baseUrl)\(subpath)", method: .post, parameters: params, headers: headers).validate().responseJSON {
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
        session.request("\(baseUrl)\(subpath)", method: .put, parameters: params, headers: headers).validate().responseJSON {
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
        session.request("\(baseUrl)\(subpath)", method: .patch, parameters: params, headers: headers).validate().responseJSON {
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
        session.request("\(baseUrl)\(subpath)", method: .delete, parameters: params, headers: headers).validate().responseJSON {
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
