//
//  NewsResponseDTO+Mapping.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation
  
// MARK: - NewsResponseDTO
struct NewsResponseDTO: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}

// MARK: - Article
struct ArticleDTO: Codable {
    let source: SourceDTO
    let author, title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct SourceDTO: Codable {
    let id: String?
    let name: String
}

//MARK: Mapping To Domain
extension NewsResponseDTO {
    func toDomain(page: Int) -> NewsModel {
        return .init(status: status,
                     totalResults: totalResults,
                     page: page,
                     articles: articles.map {$0.toDomain()})
    }
}

extension ArticleDTO {
    func toDomain() -> Article {
        return .init(source: source.toDomain(),
                     author: author,
                     title: title,
                     articleDescription: articleDescription,
                     url: url,
                     urlToImage: urlToImage,
                     publishedAt: publishedAt.formattedDate(),
                     content: content)
    }
}

extension SourceDTO {
    func toDomain() -> Source {
        return .init(id: id, name: name)
    }
}
 

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        let dateString = formatter.string(from: self)
        return dateString
    }
}
