//
//  MultipayManager.swift
//  Multipay
//
//  Created by ilker sevim on 3.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

//public typealias NetworkClientErrorCallBack = (_ errorModel: GenericErrorModel, data: ) -> Void

public protocol CancelableRequest{

    var isCancelable: Bool { get }
}

open class CustomRequest: CancelableRequest{
    
    open var isCancelable: Bool = false
    open var request: Request?
    
    init(request: Request?, isCancelable: Bool = false) {
        self.request = request
        self.isCancelable = isCancelable
    }
}

struct NetworkClient {
    
    public static let shared = NetworkClient()
    
    struct NetworkClientRetrier: RequestInterceptor {
        func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
            if let response = request.task?.response as? HTTPURLResponse, response.statusCode != 200, response.statusCode != 500 {
                completion(.retryWithDelay(0.1))
            } else {
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
    /* for SSL Pinning
     struct Certificates {
     
     static let wikimedia = Certificates.certificate(filename: "wikimedia.org")
     
     private static func certificate(filename: String) -> SecCertificate {
     let filePath = Bundle.main.path(forResource: filename, ofType: "der")!
     let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
     return SecCertificateCreateWithData(nil, data as CFData)!
     }
     }
     
     //  let evaluators = [
     //    "upload.wikimedia.org": PinnedCertificatesTrustEvaluator(certificates: [Certificates.wikimedia])
     //  ]
     */
    
    let session: Session!
    
    //let retrier: RequestInterceptor
    
    private init() {
        //self.retrier = NetworkClientRetrier()
        
        let configuration = URLSessionConfiguration.af.default
        configuration.headers = .default
        configuration.headers["Content-Type"] = "application/json"
        
//        configuration.headers["Accept"] = "*/*"
//        configuration.headers["Accept-Encoding"] = "gzip, deflate, br"
//        configuration.headers["Connection"] = "keep-alive"
        
        self.session = Session(configuration: configuration)
        
        //For SSL Pinning
        //self.session = Session(interceptor: retrier, serverTrustManager: ServerTrustManager(evaluators: evaluators))
    }
    
    static func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        
        return shared.session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    static func request(_ convertible: URLRequestConvertible) -> DataRequest {
        shared.session.request(convertible).validate().authenticate(username: Credentials.username, password: Credentials.password)
    }
    
    static func download(_ url: String) -> DownloadRequest {
        shared.session.download(url).validate()
    }
    
    static func upload(multipartFormData: @escaping (MultipartFormData) -> Void, with convertible: URLRequestConvertible) -> UploadRequest {
        shared.session.upload(multipartFormData: multipartFormData, with: convertible).validate().authenticate(username: Credentials.username, password: Credentials.password)
    }
    
    /*
    static func get(_ path:String, completion: @escaping (Result<Void, Error>) -> Void) {
        shared.session.request(path).validate().responseDecodable(of: BaseModel.self) { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    */
    
    static func post(_ serviceName:String,
                     isSdkService: Bool = true,
                     parameters: [String : AnyObject],
                     isCancelable:Bool = true,
                     displayError: Bool = true,
                     isSecure: Bool = false,
                     displaySpinner: Bool = true,
                     supportCodable: Bool = false,
                     httpMethod: HTTPMethod = .post,
                     callback: @escaping SuccessCallBack,
                     errorCallback:@escaping ErrorCallBack)
    {
               
        //let converted = parameters.compactMapValues { $0 as? String }
        let serviceParameter = parameters
        
        let url = ServiceUrl.getURL(serviceName, isSdk: isSdkService)
        
        if  (Config.isDebug) {
            print("\n\n****************SERVICE REQUEST START***************************\n\n")
            print("Service Path:")
            print(url)
            
            print("\nService Name:")
            print(serviceName)
            print("\nService Headers:")
            print(shared.session.sessionConfiguration.headers)
            print("\nService Parameters:")
            print(serviceParameter )
            print("\n\n****************SERVICE REQUEST END***************************\n\n")
        }
        
        
        shared.session.request(url, method: httpMethod, parameters: serviceParameter, encoding: JSONEncoding.default).validate().responseJSON { (response) in

            switch response.result {
            case .success(let value):
                
                //JSON
                let json = JSON(value)
                let jsonData = response.data
                
                if  (Config.isDebug) {
                    print("\n\n****************SERVICE RESPONSE START***************************\n\n")
                    print("Service Path:")
                    print(url)
        
                    print("\nService Name:")
                    print(serviceName)
                    
//                    let pretty = try! JSONSerialization.data( withJSONObject: value,
//                                                              options: .prettyPrinted)
                    
                    print("\nService RESPONSE json:" + String(data: jsonData!, encoding: .utf8)!)
                    //print(json)
                    
                    print("\n\n****************SERVICE RESPONSE END***************************\n\n")
                }
                
                callback(json.dictionaryObject! as [String : AnyObject], jsonData)
                break
                
            case .failure(let error):
                
                //JSON
                let jsonData = response.data
                
                let error = error as NSError
                                   let code = "\(error.code)"
                                   let message = error.localizedDescription
                                   let errorModel = ErrorModel(code: code, message: message)
                                    
                
                if  (Config.isDebug) {
                    print("\n\n****************SERVICE RESPONSE START***************************\n\n")
                    print("Service Path:")
                    print(url)
        
                    print("\nService Name:")
                    print(serviceName)
                    
                    print("\n Service RESPONSE code: \(code) message:\(message) ")
                    print("\nService RESPONSE json:" + String(data: jsonData ?? Data(), encoding: .utf8)!)
                    
                    print("\n\n****************SERVICE RESPONSE END***************************\n\n")
                }
                
                errorCallback(errorModel, response.data)
                
                break
            }
        }
    }
}
