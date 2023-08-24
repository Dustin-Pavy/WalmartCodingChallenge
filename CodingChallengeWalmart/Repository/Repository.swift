//
//  Repository.swift
//  CodingChallengeWalmart
//
//  Created by Dustin Pavy on 8/23/23.
//

import Foundation

protocol CountryRepositoryAction{
    func getCountryList() async throws -> [CountryElement]
}

class CountryRepository{
    let networkManager:NetworkProtocol
    
    init(networkManager:NetworkProtocol){
        self.networkManager = networkManager
    }
    
}


extension CountryRepository: CountryRepositoryAction{
    func getCountryList() async throws -> [CountryElement] {
        do{
            let fruitRequest = CountryRequest(path: Endpoint.countryEndpoint)
            let data = try await networkManager.fetchData(from: fruitRequest)
            let results = try JSONDecoder().decode([CountryElement].self, from: data)
            return results
        }catch{
            throw error
        }
    }
}
