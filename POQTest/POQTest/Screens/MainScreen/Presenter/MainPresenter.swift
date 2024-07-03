//
//  MainPresenter.swift
//  POQTest
//
//  Created by Protsak Dmytro on 03.07.2024.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    
    func fetchGitRepos()
}

final class MainPresenter: MainPresenterProtocol {
    
    private enum Constansts {
        static let url: String = "https://api.github.com/orgs/square/repos"
    }
    
    // MARK: - Private properties
    
    private weak var viewController: MainViewControllerProtocol?
    private var apiCaller: NetworkManagerProtocol
    
    // MARK: - Initializer
    
    init(
        viewController: MainViewControllerProtocol,
        apiCaller: NetworkManagerProtocol
    ) {
        self.viewController = viewController
        self.apiCaller = apiCaller
    }
    
    func fetchGitRepos() {
        
        let url = URL(string: Constansts.url)
        
        apiCaller.makeRequest(
            with: url,
            expecting: [RepositoryModel].self) { [weak self] result in
                guard let self else { return }
                switch result {
                    case .success(let gitRepos):
                        viewController?.updateView(with: gitRepos)
                    case .failure(let failure):
                        viewController?.showErrorAlert(message: failure.localizedDescription)
                }
            }
    }
}
