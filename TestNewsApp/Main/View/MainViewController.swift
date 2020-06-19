//
//  MainViewController.swift
//  TestNewsApp
//
//  Created by Саид on 16.06.2020.
//  Copyright © 2020 Саид. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    let refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl.attributedTitle = .init(string: "Uploading news...")
        return refreshControl
    }()
    
    var presenter: MainViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "News"
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        newsTableView.refreshControl = refreshControl
        
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        presenter.getNews()
        sender.endRefreshing()
    }
    
    private func createAndShowAlert() {
        let alert = UIAlertController(title: "Connection Error", message: "Please, check your internet connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "Reload", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.getNews()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension MainViewController: MainViewProtocol {
    func success() {
        newsTableView.reloadData()
    }
    
    func failure() {
        DispatchQueue.main.async {
            self.createAndShowAlert()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
    
        let news = presenter.news?[indexPath.row]
        cell.textLabel?.text = news?.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = news?.published
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = presenter.news?[indexPath.row]
        let detailVC = ModuleBuilder.createDetailModule(news: news)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
