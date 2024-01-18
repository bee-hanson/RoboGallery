//
//  RobotGridViewModel.swift
//  RoboGallery
//
//  Created by Melissa Hanson on 1/13/24.
//

import Foundation

class RobotsViewModel {
    
    private var repo: RobotDataStoring
    private var service: RobotImageServicing
    
    init(repo: RobotDataStoring, service: RobotImageServicing) {
        self.repo = repo
        self.service = service
    }
    
    var isLoading = false {
        didSet {
            self.toggleLoadingIndicator?()
        }
    }
    var errorMessage: String?
    var robots: [Robot] = []
    var updateCollectionView: (() -> Void)?
    var toggleLoadingIndicator: (() -> Void)?
    
    func getRobots() {
        robots = repo.getRobots()
    }
    
    func addRobot(name: String) async {
        isLoading = true
        
        let result = try? await service.getRobotImage(name: name)
        
        switch result {
        case .success(let imageData):
            let robot = Robot(name: name, imageData: imageData)
            
            // Per the requirements - insert the the robot at the top of the list
            robots.insert(robot, at: 0)
            repo.saveRobots(robots)
            self.updateCollectionView?()
            
        case .failure(let error):
            errorMessage = error.customDescription
            print(errorMessage!)
            
        case .none:
            errorMessage = "Unknown Error"
            print(errorMessage!)
        }
        
        isLoading = false
    }

    
    func deleteRobot(at index: Int) {
        robots.remove(at: index)
        repo.saveRobots(robots)
        self.updateCollectionView?()
    }
}
