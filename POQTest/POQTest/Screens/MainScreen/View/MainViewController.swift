//
//  MainViewController.swift
//  POQTest
//
//  Created by Protsak Dmytro on 03.07.2024.
//

import UIKit
import SnapKit

protocol MainViewControllerProtocol: AnyObject {
    
    func updateView(with gitRepos: [RepositoryModel])
    func showErrorAlert(message: String)
}

final class MainViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self)
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var presenter: MainPresenterProtocol?
    private var gitRepos: [RepositoryModel] = [RepositoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        setupTableView()
        setupViewWithData()
        activityIndicator(isShow: true)
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
    }
    
    private func setupViewWithData() {
        presenter?.fetchGitRepos()
    }
    
    private func activityIndicator(isShow: Bool) {
        isShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    // MARK: - Injection
    
    func set(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    
    func updateView(with gitRepos: [RepositoryModel]) {
        self.gitRepos = gitRepos
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator(isShow: false)
        }
    }
    
    func showErrorAlert(message: String) {
        print("Alert")
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CustomTableViewCell.self)
        let gitRepo = gitRepos[indexPath.row]
        cell.configure(title: gitRepo.name, subtitle: gitRepo.description ?? "No Info")
        return cell
    }
}
