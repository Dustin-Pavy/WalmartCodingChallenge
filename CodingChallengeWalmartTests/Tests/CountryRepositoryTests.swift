//
//  CountryRepositoryTests.swift
//  CodingChallengeWalmartTests
//
//  Created by Dustin Pavy on 8/23/23.
//

import XCTest
@testable import CodingChallengeWalmart
final class CountryRepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testFruitRepositoryWhenWeExpectEverythingIsCorrect() async throws {
        //given
        let fakeNetworkManager = FakeNetworkManager()
        let countryRepository = CountryRepository(networkManager: fakeNetworkManager)
        //when
        fakeNetworkManager.mockPath = "CountryTest"
        
        do{
            let countryList = try await countryRepository.getCountryList()
            //then
            XCTAssertNotNil(countryList)
            XCTAssertNotNil(fakeNetworkManager)
            XCTAssertEqual(countryList.count, 5)
        } catch{
            XCTAssertNil(error)
        }
    }
    
    func testFruitRepositoryWhenWeExpectNoData() async throws {
        //given
        let fakeNetworkManager = FakeNetworkManager()
        let countryRepository = CountryRepository(networkManager: fakeNetworkManager)
        //when
        fakeNetworkManager.mockPath = "CountryTestEmpty"
        
        do{
            let countryList = try await countryRepository.getCountryList()
            //then
            XCTAssertNotNil(countryList)
            XCTAssertNotNil(fakeNetworkManager)
        } catch{
            XCTAssertNotNil(error)
        }
    }

    func testFruitRepositoryWhenWeExpectParsingError() async throws {
        //given
        let fakeNetworkManager = FakeNetworkManager()
        let countryRepository = CountryRepository(networkManager: fakeNetworkManager)
        //when
        fakeNetworkManager.mockPath = "CountryTestBadParse"
        
        do{
            let countryList = try await countryRepository.getCountryList()
            //then
            XCTAssertNotNil(countryList)
            XCTAssertNotNil(fakeNetworkManager)
        } catch{
            XCTAssertNotNil(error)
        }
    }

//   func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
