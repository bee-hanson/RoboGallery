//
//  RobotRepository.swift
//  RoboGallery
//
//  Created by Melissa Hanson on 1/13/24.
//

import Foundation

protocol RobotDataStoring {
    func getRobots() -> [Robot]
    func saveRobots(_ robots: [Robot])
}

class RobotDataStore: RobotDataStoring {
    
    func getRobots() -> [Robot] {
        // wouldn't use UserDefaults for this in the real world, but using it here for time and simplicity sake
        guard let data = UserDefaults.standard.data(forKey: "robots") else {
            return []
        }
        
        do {
            let robots = try JSONDecoder().decode([Robot].self, from: data) as [Robot]
            return robots
        } catch {
            return []
        }

    }
    
    func saveRobots(_ robots: [Robot]) {
        
        do {
            let data = try JSONEncoder().encode(robots)
            UserDefaults.standard.setValue(data, forKey: "robots")
        } catch {
            print("error saving data")
        }
    }
    
}
