//
//  RobotDetailViewModelTests.swift
//  RoboGalleryTests
//
//  Created by Melissa Hanson on 1/18/24.
//

import XCTest
@testable import RoboGallery

final class RobotDetailViewModelTests: XCTestCase {
    
    func testViewModelInitializesWithRobotAndIndex() throws {
        let name = "Johnny"
        let index = 4
        
        let robot = Robot(name: name, imageData: Data())
        let viewmodel = RobotDetailViewModel(robot: robot, index: index)
        
        XCTAssertEqual(viewmodel.robot.name, name)
        XCTAssertNotNil(viewmodel.robot.imageData)
        XCTAssertEqual(viewmodel.index, index)
    }
    
}
