//
//  APICaller.swift
//  POQTest
//
//  Created by Protsak Dmytro on 03.07.2024.
//

import Foundation

// MARK: - CustomError

enum CustomError: Error {
    case invalidURL
    case invalidData
    case general
    
    var description: String {
        switch self {
            case .invalidURL:
                "Invalid URL"
            case .invalidData:
                "Invalid Data"
            case .general:
                "Something went wrong"
        }
    }
}

protocol NetworkManagerProtocol {
    
    func makeRequest<T: Decodable>(
        with url: URL?,
        expecting: T.Type ,
        completion: @escaping(Result<T, CustomError>) -> Void
    )
}

final class NetworkManager: NetworkManagerProtocol {
    
    func makeRequest<T: Decodable>(
        with url: URL?,
        expecting: T.Type,
        completion: @escaping(Result<T, CustomError>) -> Void
    ) {
        guard let url = url else {
            return completion(.failure(CustomError.invalidURL))
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return completion(.failure(CustomError.invalidData))
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(CustomError.general))
            }
        }
        task.resume()
    }
}
