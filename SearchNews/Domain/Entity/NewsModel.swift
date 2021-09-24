//
//  NewsModel.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation
 
// MARK: - NewsModel
struct NewsModel: Codable {
    let status: String
    let totalResults: Int
    let page: Int
    let articles: [Article]
}
 
struct Article: Codable {
    let source: Source
    let author, title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

struct Source: Codable {
    let id: String?
    let name: String
}
