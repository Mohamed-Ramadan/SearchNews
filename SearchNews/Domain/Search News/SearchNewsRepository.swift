//
//  SearchNewsRepository.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation
 
protocol SearchNewsRepository {
    func getNews(for query: String, page: Int,
                 cached: @escaping (NewsModel) -> Void,
                 completion: @escaping (Result<NewsResponseDTO, Error>) -> Void)
}

