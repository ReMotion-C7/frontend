//
//  APIService.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import Combine
import Foundation
import Alamofire

final class APIService {
    
    static let shared = APIService()
    
    private let host = "http://localhost:8080/api/v1/"
    
    @Published var accessToken: String? = ""
    @Published var userId: Int? = 0
    @Published var roleId: Int? = 0
    
    func post<T: Decodable>(
        _ endpoint: String,
        parameters: Parameters,
        headers: HTTPHeaders? = nil,
        responseType: T.Type
    ) async throws -> T {
        try await request(
            endpoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
            responseType: responseType
        )
    }
    
    func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?,
        responseType: T.Type
    ) async throws -> T {
        
        var finalHeaders: HTTPHeaders = headers ?? []
        
        if let token = accessToken {
            finalHeaders.add(.authorization(bearerToken: token))
        }
        
        let url = "\(host)\(endpoint)"
        print(url)
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: finalHeaders
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let failure):
                    print(
                        "🚨 API Request Failed. Error: \(failure.localizedDescription)"
                    )
                    print(
                        "📄 Raw failure data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "Unable to decode raw data")"
                    )
                    // Detect expired token (401)
                    if response.response?.statusCode == 401 {
                        print("⚠️ Unauthorized — token may be expired")
                        SessionManager.shared.logout()
                    }
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
    
}
