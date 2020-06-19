//
//  NetworkService.swift
//  TestNewsApp
//
//  Created by Саид on 16.06.2020.
//  Copyright © 2020 Саид. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol: class {
    func getNews(url: String, completion: (([News]?) -> ())?, connectionError: @escaping () -> ())
}

class NetworkService: NSObject, NetworkServiceProtocol {
    
    private var news: [News] = []
    private var currentElement: String!
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var yandex: String = "" {
        didSet {
            yandex = yandex.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([News]) -> ())?
    
    func getNews(url: String, completion: (([News]?) -> ())?, connectionError: @escaping () -> ()) {
        
        self.parserCompletionHandler = completion
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data else {
                if let er = error {
                    connectionError()
                    print(er.localizedDescription)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
        }.resume()
    }
}

extension NetworkService: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentPubDate = ""
            currentDescription = ""
            yandex = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "pubDate":
            currentPubDate += string
        case "yandex:full-text":
            yandex += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let news = News(title: currentTitle, published: currentPubDate, fullDescription: yandex)
            self.news.append(news)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(news)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
