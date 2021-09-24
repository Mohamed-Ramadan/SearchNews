//
//  SearchNewsUseCase.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation

protocol SearchNewsUseCase {
    func fetchNews(requestValue: SearchNewsUseCaseRequestValue,
                       cached: @escaping (NewsModel) -> Void,
                       completion: @escaping (Result<NewsModel, Error>) -> Void)
}

final class DefaultSearchNewsUseCase: SearchNewsUseCase {
     
    private let newsRepository: SearchNewsRepository
    
    init(newsRepository: SearchNewsRepository) {
        self.newsRepository = newsRepository
    }
    
    func fetchNews(requestValue: SearchNewsUseCaseRequestValue,
                   cached: @escaping (NewsModel) -> Void,
                   completion: @escaping (Result<NewsModel, Error>) -> Void) {
        self.newsRepository.getNews(for: requestValue.query, page: requestValue.page,
                                    cached: cached) { result in
            switch result {
                case .success(let responseDTO):
                    // return with fetched news
                    completion(.success(responseDTO.toDomain(page: requestValue.page)))
                case .failure(let error):
                    // return with error
                    completion(.failure(error))
            }
        }
    }
}

struct SearchNewsUseCaseRequestValue {
    let query: String
    let page: Int
}
