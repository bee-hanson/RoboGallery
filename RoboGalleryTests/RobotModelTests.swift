//
//  RobotModelTests.swift
//  RoboGalleryTests
//
//  Created by Melissa Hanson on 1/18/24.
//

import XCTest
@testable import RoboGallery


final class RobotModelTests: XCTestCase {
    
    func testModelInitializesSuccessfully() {
        let name = "Aspen"
        let robot = Robot(name: name, imageData: Data())
        
        XCTAssertEqual(robot.name, name)
        XCTAssertNotNil(robot.imageData)
    }
    
}
