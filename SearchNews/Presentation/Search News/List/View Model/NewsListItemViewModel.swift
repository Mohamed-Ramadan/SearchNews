//
//  NewsListItemViewModel.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation

struct NewsListItemViewModel: Equatable {
    var title: String = ""
    var description: String = ""
    var imageURL: String = ""
    var url: String = ""
    var date: String = ""
    var author: String = ""
    var source: String = ""
}

extension NewsListItemViewModel {
    init(article: Article) {
        self.title = article.title
        self.description = article.articleDescription
        self.imageURL = article.urlToImage
        self.url = article.url
        self.date = article.publishedAt
        self.author = article.author
        self.source = article.source.name
    }
}

