//
//  MainPresenter.swift
//  TestNewsApp
//
//  Created by Саид on 16.06.2020.
//  Copyright © 2020 Саид. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    func success()
    func failure()
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkService)
    func getNews()
    var news: [News]? { get set }
}

class MainPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var networkService: NetworkServiceProtocol
    var news: [News]?
    
    required init(view: MainViewProtocol, networkService: NetworkService) {
        self.view = view
        self.networkService = networkService
        getNews()
    }
    
    func getNews() {
        networkService.getNews(url: "https://www.vesti.ru/vesti.rss", completion: { [weak self] news in
            
            guard let self = self else { return }
            
            self.news = news
            DispatchQueue.main.async {
                self.view?.success()
            }
            
        }) { 
            self.view?.failure()
        }
    }
}
