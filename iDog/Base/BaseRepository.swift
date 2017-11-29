//
//  BaseRepository.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum RepositoryError: Error {
    case unknown
}

class BaseRepository {
    
    typealias ThenBlock = (DataResponse<Data>) -> Void
    
    var baseUrl = "https://hidden-crag-71735.herokuapp.com/api/"
    
    var url: String
    let urlSuffix = ""
    
    init(url: String) {
        self.url = url
    }
    
    var alamofireManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 31
        configuration.timeoutIntervalForRequest = 31
        let alamofireManager = Alamofire.SessionManager(configuration: configuration)
        return alamofireManager
    }()
    
    func createHeader() -> [String: String] {
        let dict = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        //        if let accessToken = Session.sharedInstance.accessToken  {
        //            dict["Authorization"] = "Bearer \(accessToken)"
        //        }
        
        return dict
    }
    
    // MARK: - REST API
    func all(_ then: @escaping ThenBlock) {
        get("\(baseUrl)\(url)\(urlSuffix)", then: then)
    }
    
    func create(_ parameters: [String: Any], then: @escaping ThenBlock) {
        post("\(baseUrl)\(url)\(urlSuffix)", parameters: parameters, then: then)
    }
    
    func find(_ identifier: Int, then: @escaping ThenBlock) {
        get("\(baseUrl)\(url)/\(identifier)\(urlSuffix)", then: then)
    }
    
    func update(_ identifier: Int, parameters: [String: Any], then: @escaping ThenBlock) {
        put("\(baseUrl)\(url)/\(identifier)\(urlSuffix)", parameters: parameters, then: then)
    }
    
    func remove(_ identifier: Int, then: @escaping ThenBlock) {
        delete("\(baseUrl)\(url)/\(identifier)\(urlSuffix)", then: then)
    }
    
    // MARK: - Custom Methods
    func customPost(_ url: String = "", parameters: [String: Any], encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil, then: @escaping ThenBlock) {
        post("\(baseUrl)\(self.url)\(url)\(urlSuffix)", parameters: parameters, encoding: encoding, headers: headers, then: then)
    }
    
    func customGet(_ url: String = "", parameters: [String: Any]? = nil, then: @escaping ThenBlock) {
        get("\(baseUrl)\(self.url)\(url)\(urlSuffix)", parameters: parameters, then: then)
    }
    
    func customPut(_ url: String = "", parameters: [String: Any] = [String: Any](), then: @escaping ThenBlock) {
        put("\(baseUrl)\(self.url)\(url)\(urlSuffix)", parameters: parameters, then: then)
    }
    
    // MARK: - HTTP VERBS
    func get(_ url: String, parameters: [String: Any]? = nil, then: @escaping ThenBlock) {
        alamofireManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: createHeader())
            .validate().responseData { (response) in
                self.handleResponse(response, then: then)
        }
    }
    
    func post(_ url: String, parameters: [String: Any], encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil, then: @escaping ThenBlock) {
        alamofireManager.request(url, method: .post, parameters: parameters, encoding: encoding, headers: headers ?? createHeader())
            .validate()
            .responseData { response in
                self.handleResponse(response, then: then)
        }
    }
    
    func delete(_ url: String, encoding: ParameterEncoding = JSONEncoding.default, then: @escaping ThenBlock) {
        alamofireManager.request(url, method: .delete, parameters: nil, encoding: encoding, headers: createHeader())
            .validate().responseData { response in
                self.handleResponse(response, then: then)
        }
    }
    
    func put(_ url: String, parameters: [String: Any], encoding: ParameterEncoding = JSONEncoding.default, then: @escaping ThenBlock) {
        alamofireManager.request(url, method: .put, parameters: parameters, encoding: encoding, headers: createHeader())
            .validate().responseData { response in
                self.handleResponse(response, then: then)
        }
    }
    
    // MARK: - Upload
    func upload(url: String, parameters: [String: Any], image: UIImage, then: @escaping ThenBlock) {
        let urlAux = "\(baseUrl)\(self.url)\(url)"
        
        alamofireManager.upload(multipartFormData: { (multipartFormData) in
            print("URL: \(urlAux)")
            
            if let imageData = UIImagePNGRepresentation(image) {
                multipartFormData.append(imageData, withName: "arquivo", fileName: "pic.png", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                if let value = value as? String, let valueData = value.data(using: .utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }
        }, to: urlAux, method: .post, headers: [
            //"Authorization": Session.sharedInstance.accessToken!,
            "Content-Type": "multipart/form-data"], encodingCompletion: { result in
                dump("\(result)")
                
                switch result {
                case .success(let upload, _, _):
                    upload.response { response in
                        //                        if let token = response.response?.allHeaderFields["Authorization"] as? String {
                        //                            Session.sharedInstance.accessToken = token
                        //                        }
                        debugPrint(response)
                        
                        var error: String?
                        if let data = response.data {
                            error = String(data: data, encoding: .utf8)
                        }
                        let result = Result<Data>.failure(NSError(domain: "error", code: 420, userInfo: ["error" : error ?? "Unkown Error :("]))
                        let dataResponse = DataResponse(request: nil, response: nil, data: nil, result: result)
                        then(dataResponse)
                    }
                    
                case .failure(let encodingError):
                    print("error: \(encodingError)")
                    
                    let result = Result<Data>.failure(NSError(domain: "error", code: 420, userInfo: ["error" : "error"]))
                    let dataResponse = DataResponse(request: nil, response: nil, data: nil, result: result)
                    then(dataResponse)
                }
        })
    }
    
    // MARK: - Response
    func handleResponse(_ response: DataResponse<Data>, then: @escaping ThenBlock) {
        printLog(response: response)
        then(response)
    }
    
    func printLog(response: DataResponse<Data>) {
        print("==================================================")
        print(response.request?.httpMethod ?? "NO METHOD")
        print(response.request?.url?.absoluteString ?? "NO URL")
        
        if let httpBody = response.request?.httpBody {
            print(NSString(data: httpBody, encoding: String.Encoding.utf8.rawValue) ?? "NO REQUEST DATA")
        }
        
        if !response.result.isSuccess {
            print("==================== ERRO ====================")
            if let data = response.data, let message = JSON(data)["error_description"].string {
                print(data)
                print("Error description: " + message)
            } else {
                print(response.error?.localizedDescription ?? "Unkown Erro")
            }
        }
        
        
        print(response.result.value ?? "NO RESULT VALUE")
    }
}
