//
//  POQTests.swift
//  POQTests
//
//  Created by Protsak Dmytro on 03.07.2024.
//

import XCTest
@testable import POQ

final class POQTests: XCTestCase {
    
    var presenter: MainPresenter!
    var mockViewController: MockMainViewController!
    var mockNetworkManager: MockNetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockViewController = MockMainViewController()
        mockNetworkManager = MockNetworkManager()
        presenter = MainPresenter(viewController: mockViewController, networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        presenter = nil
        mockViewController = nil
        mockNetworkManager = nil
        try super.tearDownWithError()
    }

    func testFetchGitRepos_Success() throws {
        // Arrange
        let expectedRepos = [
            RepositoryModel(name: "Repo1", description: "Description1"),
            RepositoryModel(name: "Repo2", description: "Description2")
        ]
        mockNetworkManager.mockData = expectedRepos

        // Act
        let expectation = XCTestExpectation(description: "Fetch repos")
        presenter.fetchGitRepos()
        DispatchQueue.main.async {
            // Assert
            XCTAssertEqual(self.mockViewController.gitRepos, expectedRepos)
            XCTAssertNil(self.mockViewController.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchGitRepos_Failure() throws {
        // Arrange
        mockNetworkManager.shouldReturnError = true

        // Act
        let expectation = XCTestExpectation(description: "Fetch repos with error")
        presenter.fetchGitRepos()
        DispatchQueue.main.async {
            // Assert
            XCTAssertTrue(self.mockViewController.gitRepos.isEmpty)
            XCTAssertEqual(self.mockViewController.errorMessage, CustomError.general.description)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
