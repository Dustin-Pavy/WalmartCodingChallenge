//
//  ViewModelTests.swift
//  CodingChallengeWalmartTests
//
//  Created by Dustin Pavy on 8/23/23.
//

import XCTest
@testable import CodingChallengeWalmart

final class ViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testFruitListWhenWeExpectCorrectData() async throws{
        
        let mockRepository = MockRepository()
        let viewModel = await ViewModel(repository: mockRepository)
        
        mockRepository.setCountryList(list: CountryElement.mockCountryList())
        await viewModel.getListFromApi()
        
        XCTAssertNotNil(viewModel)
        let countryList = await viewModel.countryList
        XCTAssertEqual(countryList.count, 1)
        
        let firstCountry = countryList.first
        XCTAssertEqual(firstCountry?.capital, "Pago Pago")
        XCTAssertEqual(firstCountry?.code, "AS")
        
        let error = await viewModel.customError
        XCTAssertNil(error)
    }
    
    func testFruitListWhenWeExpectInvalidURL() async throws{
        
        let mockRepository = MockRepository()
        let viewModel = await ViewModel(repository: mockRepository)
        
        mockRepository.setError(error: CustomNetworkError.invalidURL)
        await viewModel.getListFromApi()
        
        XCTAssertNotNil(viewModel)
        let countryList = await viewModel.countryList
        XCTAssertEqual(countryList.count, 0)
        
        let firstCountry = countryList.first
        XCTAssertNil(firstCountry)
        
        let error = await viewModel.customError
        XCTAssertEqual(error, CustomNetworkError.invalidURL)
    }
    
    func testFruitListWhenWeExpectWrongURL() async throws{
        
        let mockRepository = MockRepository()
        let viewModel = await ViewModel(repository: mockRepository)
        
        mockRepository.setError(error: CustomNetworkError.dataNotFound)
        await viewModel.getListFromApi()
        
        XCTAssertNotNil(viewModel)
        let countryList = await viewModel.countryList
        XCTAssertEqual(countryList.count, 0)
        
        let firstCountry = countryList.first
        XCTAssertNil(firstCountry)
        
        let error = await viewModel.customError
        XCTAssertEqual(error, CustomNetworkError.dataNotFound)
    }

    func testFruitListWhenWeExpectParsingError() async throws{
        
        let mockRepository = MockRepository()
        let viewModel = await ViewModel(repository: mockRepository)
        
        mockRepository.setError(error: CustomNetworkError.parsingFailed)
        await viewModel.getListFromApi()
        
        XCTAssertNotNil(viewModel)
        let countryList = await viewModel.countryList
        XCTAssertEqual(countryList.count, 0)
        
        let firstCountry = countryList.first
        XCTAssertNil(firstCountry)
        
        let error = await viewModel.customError
        XCTAssertEqual(error, CustomNetworkError.parsingFailed)
    }


//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
