//
//  ViewModel.swift
//  CodingChallengeWalmart
//
//  Created by Dustin Pavy on 8/23/23.
//

import Foundation

enum ViewStates{
    case loading
    case errorState
    case loaded
    case emptyView
}

@MainActor
class ViewModel: ObservableObject{
    @Published var countryList = [CountryElement]()
    @Published var countryListFiltered: [CountryElement] = []
    @Published var customError: CustomNetworkError?
    @Published private(set) var viewState:ViewStates = .loaded
    
    var repository:CountryRepositoryAction
    
    init(repository:CountryRepositoryAction){
        self.repository = repository
    }
    
    func getListFromApi() async{
        viewState = .loading
        
        do{
            let results = try await self.repository.getCountryList()
            if results.isEmpty{
                self.viewState = .emptyView
            } else{
                self.countryList = results
                print(self.countryList)
                viewState = .loaded
            }
        }catch let error{
            switch error{
            case is DecodingError:
                customError = CustomNetworkError.parsingFailed
            case is URLError:
                customError = CustomNetworkError.invalidURL
            case CustomNetworkError.dataNotFound:
                customError = CustomNetworkError.dataNotFound
            case CustomNetworkError.invalidResponse:
                customError = CustomNetworkError.invalidResponse
            case CustomNetworkError.invalidURL:
                customError = CustomNetworkError.invalidURL
            case CustomNetworkError.parsingFailed:
                customError = CustomNetworkError.parsingFailed
            default:
                customError = CustomNetworkError.dataNotFound
            }
        }
        
    }
    
}
