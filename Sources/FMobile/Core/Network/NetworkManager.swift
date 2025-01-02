//
//  File.swift
//
//
//  Created by Ishipo on 11/8/24.
//

import Foundation
import UIKit
import Combine

internal class NetworkManager: NSObject {
    static var shared = NetworkManager()
    
    public func getSuperConfig() -> AnyPublisher<ConfigData, Error> {
        let url = URL(string: "https://fm.n76i.com/api/application-raw")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = getAuthHeader()
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { element in
                guard let response = element.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
//                if let authHeader = response.allHeaderFields[FMobileConstants.HEADER_SDK_AUTH] {
//                    print("HEADER_AUTHORIZATION", authHeader)
//                } else {
//                    print("HEADER_AUTHORIZATION not found in response")
//                }
                return element.data
            }
        
            .decode(type: BaseResponse.self, decoder: JSONDecoder())
            .map {$0.data}
            .mapError { error -> Error in
                
                if let urlError = error as? URLError {
                    // Lỗi kết nối mạng
                    print("Network error: \(urlError.localizedDescription)")
                    return urlError
                } else if let decodingError = error as? DecodingError {
                    // Lỗi khi decode dữ liệu JSON
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch error: \(type) - \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value not found error: \(type) - \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Key not found error: \(key) - \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Data corrupted error: \(context.debugDescription)")
                    default:
                        print("Decoding error: \(decodingError.localizedDescription)")
                    }
                    return decodingError
                }
                // Trả về lỗi khác không xác định
                print("Unknown error: \(error.localizedDescription)")
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func getAuthHeader() -> [String : String] {
        let sec = FMobileConstants.SECRET_BASE64.decodeBase64() ?? ""
        
        let payload: [String : Any] = [
            "b" : "template",
            "t" : Date().millisecondsSince1970,
            "p": "iOS",
            "e": FMobileConfig.environment.rawValue,
            "l": (FMobileConfig.licenseKey + "bood").md5()
        ]
        
        let payloadJSON = payload.toJson() ?? ""
        
        let payloadEncrypt = payloadJSON.toBase64()
        
        let signature = (payloadJSON + sec).md5()
        
        let authHeader = "\(payloadEncrypt).\(signature)"
        
        return [FMobileConstants.HEADER_SDK_AUTH: authHeader]
    }
}
