//
//  MockNetworkManager.swift
//  POQTestTests
//
//  Created by Дмитрий Процак on 03.07.2024.
//

import Foundation
@testable import POQTest

class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockData: [RepositoryModel] = []

    func makeRequest<T: Decodable>(
        with url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, CustomError>) -> Void
    ) {
        if shouldReturnError {
            completion(.failure(.general))
        } else {
            completion(.success(mockData as! T))
        }
    }
}
