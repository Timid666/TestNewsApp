//
//  ModuleBuilder.swift
//  TestNewsApp
//
//  Created by Саид on 16.06.2020.
//  Copyright © 2020 Саид. All rights reserved.
//

import UIKit

protocol Builder: class {
    static func createMainModule() -> UIViewController
    static func createDetailModule(news: News?) -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = MainPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    static func createDetailModule(news: News?) -> UIViewController {
        let view = DetailViewController()
        let networkService = NetworkService()
        let presenter = DetailPresenter(view: view, networkService: networkService, news: news)
        view.presenter = presenter
        return view
    }
}
