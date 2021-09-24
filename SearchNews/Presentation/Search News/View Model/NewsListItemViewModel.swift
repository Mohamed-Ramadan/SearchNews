//
//  NewsListItemViewModel.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation

struct NewsListItemViewModel: Equatable {
    var title: String = ""
    var subTitle: String = ""
}

extension NewsListItemViewModel {
    init(article: Article) {
        self.title = article.title
        self.subTitle = article.articleDescription
    }
}

