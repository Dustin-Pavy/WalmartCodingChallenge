//
//  FakeNetworkManager.swift
//  CodingChallengeWalmartTests
//
//  Created by Dustin Pavy on 8/23/23.
//

import Foundation

@testable import CodingChallengeWalmart

class FakeNetworkManager: NetworkProtocol{
    
    var mockPath = ""
    func fetchData(from urlRequest: Requestable) async throws -> Data {
        let bundle = Bundle(for: FakeNetworkManager.self)
        
        guard let url = bundle.url(forResource: mockPath, withExtension: "json")
        else{
            throw CustomNetworkError.invalidURL
        }
        
        do{
            let data = try Data(contentsOf: url)
            return data
        }catch{
            print(error.localizedDescription)
            throw error
        }
    }
}
