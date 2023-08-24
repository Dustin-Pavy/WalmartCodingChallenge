//
//  NetworkServices.swift
//  CodingChallengeWalmart
//
//  Created by Dustin Pavy on 8/23/23.
//

import Foundation

//MARK: Protocol
protocol NetworkProtocol{
    func fetchData(from urlRequest: Requestable) async throws -> Data
}

protocol NetworkManagerSessionable{
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}
extension URLSession: NetworkManagerSessionable{
    func data(for request: URLRequest, delegate: URLSessionDelegate?) async throws -> (Data, URLResponse) {
        try await self.data(for: request)
    }
}

//MARK: Manager
class NetworkManager{
    
    var urlSession: NetworkManagerSessionable
    
    init(urlSession: NetworkManagerSessionable = URLSession.shared) {
        self.urlSession = urlSession
    }
}
extension NetworkManager: NetworkProtocol{
    
    
    func fetchData(from urlRequest: Requestable) async throws -> Data {
        do {
            guard let request = urlRequest.createURLRequest() else {
                throw CustomNetworkError.invalidURL
            }
            let (data, response) = try await urlSession.data(for: request, delegate: nil)
            guard response.isValidResponse() else {
                throw CustomNetworkError.invalidResponse
            }
            return data
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

extension URLResponse{
    func isValidResponse() -> Bool{
        guard let response = self as? HTTPURLResponse else {return false}
        
        switch response.statusCode{
        case 200...299:
            return true
            
        case 400...499:
            return false
        default:
            return false
            
        }
    }
}

//MARK: Errors
enum CustomNetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case dataNotFound
    case parsingFailed
    
    var errorDescription: String? {
        switch self {
        case .parsingFailed:
            return NSLocalizedString("Received response couldn't be parsed", comment: "Parsing Failed")
        case .invalidResponse:
            return NSLocalizedString("Received invalid status code", comment: "Invalid Response")
        case .dataNotFound:
            return NSLocalizedString("No response received from API", comment: "Data Not Found")
        case .invalidURL:
            return NSLocalizedString("The provided endpoint was incorrect", comment: "Invalid URL")
        }
    }
    
    static func getCustomNetworkError(from error: Error) -> CustomNetworkError {
        switch error {
        case is DecodingError:
            return CustomNetworkError.parsingFailed
        case is URLError:
            return CustomNetworkError.invalidURL
        case CustomNetworkError.dataNotFound:
            return CustomNetworkError.dataNotFound
        case CustomNetworkError.invalidResponse:
            return CustomNetworkError.invalidResponse
        default:
            return CustomNetworkError.dataNotFound
        }
    }
}
