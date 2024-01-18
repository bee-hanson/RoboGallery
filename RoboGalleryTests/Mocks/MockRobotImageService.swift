//
//  MockRobotImageService.swift
//  RoboGalleryTests
//
//  Created by Melissa Hanson on 1/18/24.
//

import Foundation
@testable import RoboGallery


class MockSuccesfulRobotImageService: RobotImageServicing {
    var getImageCount = 0
    
    func getRobotImage(name: String) async throws -> Result<Data, RoboGallery.APIError> {
        getImageCount += 1
        return .success(Data())
    }
}

class MockInvalidUrlRobotImageService: RobotImageServicing {
    func getRobotImage(name: String) async throws -> Result<Data, RoboGallery.APIError> {
        return .failure(.invalidUrl)
    }
}


class MockRequestFailedRobotImageService: RobotImageServicing {
    func getRobotImage(name: String) async throws -> Result<Data, RoboGallery.APIError> {
        return .failure(.requestFailed(description: "Something Went Wrong"))
    }
}

class MockInvalidStatusCodeRobotImageService: RobotImageServicing {
    func getRobotImage(name: String) async throws -> Result<Data, RoboGallery.APIError> {
        return .failure(.invalidStatusCode(statusCode: 400))
    }
}

class MockUnknownErrorRobotImageService: RobotImageServicing {
    func getRobotImage(name: String) async throws -> Result<Data, RoboGallery.APIError> {
        return .failure(.unknownError(errorMessage: "Something Went Wrong"))
    }
}
