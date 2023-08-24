//
//  NetworkTests.swift
//  CodingChallengeWalmartTests
//
//  Created by Dustin Pavy on 8/23/23.
//

import XCTest
@testable import CodingChallengeWalmart

final class NetworkTests: XCTestCase {

    
    static let testUrl = "testUrl"
    static let testData = "testData".data(using: .utf8)
    static let testPath = "testPath"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNetWorkManager_getDataFromAPI_WhenEverythingIsCorrect() async throws {
        //Given
        let urlSession = MockUrlSession()
        let networkManager = NetworkManager()
        do {
            //When
            let dummyData = NetworkTests.testData
            let urlResponse = HTTPURLResponse(url: URL(string: NetworkTests.testUrl)!, statusCode: 200, httpVersion: nil, headerFields: nil)

            urlSession.setMockData(data: dummyData!)
            urlSession.setUrlResponse(urlResponse: urlResponse!)

            let req =  CountryRequest(path: NetworkTests.testPath)
            let data = try await networkManager.fetchData(from: req)
            //Then
            XCTAssertNotNil(data)
        }catch let error {
            XCTAssertNotNil(error)
        }
    }

    func testNetWorkManager_getDataFromAPI_WhenItGives404Error() async throws {
        //Given
        let urlSession = MockUrlSession()
        let networkManager = NetworkManager(urlSession: urlSession)
        do {
            //When
            let dummyData = "random".data(using: .utf8)
            let urlResponse = HTTPURLResponse(url: URL(string: "testURL")!, statusCode: 404, httpVersion: nil, headerFields: nil)

            urlSession.setMockData(data: dummyData!)
            urlSession.setUrlResponse(urlResponse: urlResponse!)
            let req =  CountryRequest(path: "404")
            _ = try await networkManager.fetchData(from: req)
        }catch let error {
            //Then
            XCTAssertEqual(error as! CustomNetworkError, CustomNetworkError.invalidResponse)
        }
    }

    func testNetWorkManager_getDataFromAPI_WhenDataNotFoundError() async throws {
        //Given
        let urlSession = MockUrlSession()
        let networkManager = NetworkManager(urlSession: urlSession)
        do {
            //When
            urlSession.setError(error: CustomNetworkError.dataNotFound)
            let req =  CountryRequest(path: "404")
            _ = try await networkManager.fetchData(from: req)
        }catch let error {
            //Then
            XCTAssertEqual(error as! CustomNetworkError, CustomNetworkError.dataNotFound)
        }
    }

    func testNetWorkManager_getDataFromAPI_WhenInvalidUrlError() async throws {
        //Given
        let urlSession = MockUrlSession()
        let networkManager = NetworkManager(urlSession: urlSession)
        do {
            //When
            urlSession.setError(error: CustomNetworkError.invalidURL)
            let req = CountryRequest(path: "404")
            _ = try await networkManager.fetchData(from: req)
        }catch let error {
            //Then
            XCTAssertEqual(error as! CustomNetworkError, CustomNetworkError.invalidURL)
        }
    }

    func testNetWorkManager_getDataFromAPI_WhenParsingError() async throws {
        //Given
        let urlSession = MockUrlSession()
        let networkManager = NetworkManager(urlSession: urlSession)
        do {
            //When
            urlSession.setError(error: CustomNetworkError.parsingFailed)
            let req = CountryRequest(path: "CountryTestBadParse")
            _ = try await networkManager.fetchData(from: req)
        }catch let error {
            //Then
            XCTAssertEqual(error as! CustomNetworkError, CustomNetworkError.parsingFailed)
        }
    }


//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
