//
//  RoboGalleryTests.swift
//  RoboGalleryTests
//
//  Created by Melissa Hanson on 1/12/24.
//

import XCTest
@testable import RoboGallery

final class RobotsViewModelTests: XCTestCase {


    // Get Robots Tests
    func testCanGetRobotsFromDataStore() throws {
        let mockDataStore = MockRobotDataStore()
        let viewmodel = RobotsViewModel(repo: mockDataStore, service: MockSuccesfulRobotImageService())
        
        viewmodel.getRobots()
        
        XCTAssertEqual(viewmodel.robots.count, 2)
        XCTAssertEqual(mockDataStore.getRobotsCallCount, 1)
    }
    
    // Add Robot Tests
    func testAddRobotAddsToIndex0() async throws {
        let name = "Harry"
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: MockSuccesfulRobotImageService())
        
        viewmodel.getRobots()
        await viewmodel.addRobot(name: name)
        
        XCTAssertEqual(viewmodel.robots.count, 3)
        XCTAssertTrue(viewmodel.robots[0].name == name)
    }
    
    func testAddRobotUpdatesRobotDataStore() async throws {
        let mockDataStore = MockRobotDataStore()
        let name = "Dobby"
        let viewmodel = RobotsViewModel(repo: mockDataStore, service: MockSuccesfulRobotImageService())
        
        viewmodel.getRobots()
        XCTAssertEqual(viewmodel.robots.count, 2)
        XCTAssertEqual(mockDataStore.robots.count, 2)

        await viewmodel.addRobot(name: name)
        XCTAssertEqual(viewmodel.robots.count, 3)
        XCTAssertEqual(mockDataStore.robots.count, 3)
    }
    
    func testAddRobotCallsSaveRobotsOnlyOnce() async throws {
        let mockDataStore = MockRobotDataStore()
        let name = "Dumbledore"
        let viewmodel = RobotsViewModel(repo: mockDataStore, service: MockSuccesfulRobotImageService())
        
        await viewmodel.addRobot(name: name)
        XCTAssertEqual(mockDataStore.saveRobotsCallCount, 1)
    }
    
    func testAddRobotCallsGetImageOnlyOnce() async throws {
        let mockImageService = MockSuccesfulRobotImageService()
        let name = "Ron"
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: mockImageService)
        
        await viewmodel.addRobot(name: name)
        XCTAssertEqual(mockImageService.getImageCount, 1)
    }
    
    
    func testAddRobotSuccessErrorMessageIsNil() async throws {
        let name = "Alexa"
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: MockSuccesfulRobotImageService())
        
        viewmodel.getRobots()
        await viewmodel.addRobot(name: name)
        
        XCTAssertEqual(viewmodel.robots.count, 3)
        XCTAssertNil(viewmodel.errorMessage)
    }
    
    func testAddRobotErrorRobotNotAdded() async throws {
        let name = "Siri"
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: MockInvalidUrlRobotImageService())
        
        viewmodel.getRobots()
        XCTAssertEqual(viewmodel.robots.count, 2)

        await viewmodel.addRobot(name: name)
        XCTAssertEqual(viewmodel.robots.count, 2)
    }
    
    func testAddRobotInvalidUrlHasErrorMessage() async throws {
        let name = "Cairo"
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: MockInvalidUrlRobotImageService())
        
        viewmodel.getRobots()
        await viewmodel.addRobot(name: name)
        XCTAssertEqual(viewmodel.robots.count, 2)
        XCTAssertEqual(viewmodel.errorMessage, "Invalid URL")
    }
    
    func testAddRobotRequestFailedHasErrorMessage() async throws {
        let name = "Paris"
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: MockRequestFailedRobotImageService())
        
        viewmodel.getRobots()
        await viewmodel.addRobot(name: name)
        XCTAssertEqual(viewmodel.robots.count, 2)
        XCTAssertEqual(viewmodel.errorMessage, "Request failed: Something Went Wrong")
    }
    
    func testAddRobotInvalidStatusCodeHasErrorMessage() async throws {
        let name = "Sydney"
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: MockInvalidStatusCodeRobotImageService())
        
        viewmodel.getRobots()
        await viewmodel.addRobot(name: name)
        XCTAssertEqual(viewmodel.robots.count, 2)
        XCTAssertEqual(viewmodel.errorMessage, "Invalid Status Code: 400")
    }

    func testAddRobotUnknownErrorHasErrorMessage() async throws {
        let name = "London"
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: MockUnknownErrorRobotImageService())
        
        viewmodel.getRobots()
        await viewmodel.addRobot(name: name)
        XCTAssertEqual(viewmodel.robots.count, 2)
        XCTAssertEqual(viewmodel.errorMessage, "An unknown error occurred: Something Went Wrong")
    }

   // Delete Robot Tests
    func testCanDeleteRobotSuccesfully() {
        let viewmodel = RobotsViewModel(repo: MockRobotDataStore(), service: MockUnknownErrorRobotImageService())
        
        viewmodel.getRobots()
        XCTAssertEqual(viewmodel.robots.count, 2)

        viewmodel.deleteRobot(at: 0)
        XCTAssertEqual(viewmodel.robots.count, 1)
        XCTAssertEqual(viewmodel.robots[0].name, "Max")
    }
    
    func testDeleteRobotCallsSaveRobotsOnlyOnce() {
        let mockDataStore = MockRobotDataStore()
        let viewmodel = RobotsViewModel(repo: mockDataStore, service: MockUnknownErrorRobotImageService())
        
        viewmodel.getRobots()
        viewmodel.deleteRobot(at: 0)
        XCTAssertEqual(mockDataStore.saveRobotsCallCount, 1)
    }
    
    func testDeleteRobotUpdatesRobotDataStore() {
        let mockDataStore = MockRobotDataStore()
        let viewmodel = RobotsViewModel(repo: mockDataStore, service: MockUnknownErrorRobotImageService())
        
        viewmodel.getRobots()
        XCTAssertEqual(viewmodel.robots.count, 2)
        XCTAssertEqual(mockDataStore.robots.count, 2)
        
        viewmodel.deleteRobot(at: 0)
        XCTAssertEqual(viewmodel.robots.count, 1)
        XCTAssertEqual(mockDataStore.robots.count, 1)
    }

}
