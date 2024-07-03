//
//  MainAssembly.swift
//  POQTest
//
//  Created by Protsak Dmytro on 03.07.2024.
//

import UIKit

protocol Presentable {
    
    func toPresent() -> UIViewController
}

final class MainAssembly: Presentable {
    
    // MARK: - Methods
    
    func toPresent() -> UIViewController {
        let apiCaller = NetworkManager()
        let viewController = MainViewController()
        let presenter = MainPresenter(
            viewController: viewController,
            apiCaller: apiCaller
        )
        viewController.set(presenter: presenter)
        return viewController
    }
}
