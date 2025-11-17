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
    
    private let host = "https://backend-production-7825.up.railway.app/api/v1/"
    
    @Published var accessToken: String? = ""
    @Published var userId: Int? = 0
    @Published var roleId: Int? = 0
    
    func requestAPI<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoder: JSONDecoder? = nil,
        responseType: T.Type
    ) async throws -> T {
        try await request(
            endpoint,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
            decoder: decoder,
            responseType: responseType
        )
    }
    
    func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?,
        decoder: JSONDecoder? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        var finalHeaders: HTTPHeaders = headers ?? []
        
        if let token = accessToken {
            finalHeaders.add(.authorization(bearerToken: token))
        }
        
        let url = "\(host)\(endpoint)"
        print(url)
        
        let effectiveDecoder = decoder ?? JSONDecoder()
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: finalHeaders
            )
            .validate()
            .responseDecodable(of: T.self, decoder: effectiveDecoder) { response in
                
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
