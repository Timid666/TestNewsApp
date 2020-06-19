//
//  DetailPresenter.swift
//  TestNewsApp
//
//  Created by Саид on 18.06.2020.
//  Copyright © 2020 Саид. All rights reserved.
//

import Foundation

protocol DetailViewProtocol: class {
    func detailedNews(news: News?)
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol, networkService: NetworkService, news: News?)
    func getNews()
}

class DetailPresenter: DetailViewPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    var networkService: NetworkService!
    var news: News?
    
    required init(view: DetailViewProtocol, networkService: NetworkService, news: News?) {
        self.view = view
        self.networkService = networkService
        self.news = news
    }
    
    func getNews() {
        self.view?.detailedNews(news: news)
    }
}
