//
//  DetailViewController.swift
//  TestNewsApp
//
//  Created by Саид on 18.06.2020.
//  Copyright © 2020 Саид. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    
    var presenter: DetailViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.getNews()
    }
}

extension DetailViewController: DetailViewProtocol {
    
    func detailedNews(news: News?) {
        newsTitleLabel.text = news?.title
        newsLabel.text = news?.fullDescription
    }
}
