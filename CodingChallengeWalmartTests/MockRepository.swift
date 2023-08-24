//
//  MockRepository.swift
//  CodingChallengeWalmartTests
//
//  Created by Dustin Pavy on 8/23/23.
//

import Foundation
@testable import CodingChallengeWalmart
class MockRepository:CountryRepositoryAction{
    
    private var error:CustomNetworkError?
    private var countryList: [CountryElement]?
    
    func getCountryList() async throws -> [CountryElement] {
        if error != nil{
            throw error!
        }
        return countryList!
    }
    
    func setCountryList(list:[CountryElement]){
        self.countryList = list
    }
    
    func setError(error:CustomNetworkError){
        self.error = error
    }
}

