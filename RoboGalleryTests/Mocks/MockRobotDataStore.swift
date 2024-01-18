//
//  MockRobotDataStore.swift
//  RoboGalleryTests
//
//  Created by Melissa Hanson on 1/18/24.
//

import Foundation
@testable import RoboGallery

class MockRobotDataStore: RobotDataStoring {
    
    var robots = [Robot(name: "Ryan", imageData: Data()), Robot(name: "Max", imageData: Data())]
    var getRobotsCallCount = 0
    var saveRobotsCallCount = 0
    
    func getRobots() -> [RoboGallery.Robot] {
        getRobotsCallCount += 1
        return self.robots
    }
    
    func saveRobots(_ robots: [RoboGallery.Robot]) {
        saveRobotsCallCount += 1
        self.robots = robots
    }
    
}
