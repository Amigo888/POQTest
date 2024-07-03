//
//  MockMainViewController.swift
//  POQTestTests
//
//  Created by Protsak Dmytro on 03.07.2024.
//

import Foundation
@testable import POQTest

class MockMainViewController: MainViewControllerProtocol {
    var gitRepos: [RepositoryModel] = []
    var errorMessage: String?

    func updateView(with gitRepos: [RepositoryModel]) {
        self.gitRepos = gitRepos
    }

    func showErrorAlert(message: String) {
        self.errorMessage = message
    }
}
