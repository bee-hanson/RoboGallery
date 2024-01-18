//
//  NetworkManager.swift
//  RoboGallery
//
//  Created by Melissa Hanson on 1/13/24.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(errorMessage: String)
    
    var customDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case let .requestFailed(description):
            return "Request failed: \(description)"
        case let .invalidStatusCode(statusCode):
            return "Invalid Status Code: \(statusCode)"
        case let .unknownError(error):
            return "An unknown error occurred: \(error)"
        }
    }
}

protocol RobotImageServicing {
    func getRobotImage(name: String) async throws -> Result<Data, APIError>
}

class RobotImageService: RobotImageServicing {
    
    func getRobotImage(name: String) async throws -> Result<Data, APIError>  {

        guard let url = URL(string: "https://robohash.org/\(name)") else { 
            return .failure(.invalidUrl)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.requestFailed(description: "Invalid HTTP Response"))
            }
            
            guard httpResponse.statusCode == 200 else {
                return .failure(.invalidStatusCode(statusCode: httpResponse.statusCode))
            }
            
            return .success(data)
            
        } catch {
            return .failure(.unknownError(errorMessage: error.localizedDescription))
        }
        
    }
}
