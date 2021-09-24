//
//  DefaultSearchNewsRepository.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation
   
class DefaultSearchNewsRepository: SearchNewsRepository {
      
    var localStorage: NewsResponseStorage?
    var networkService: NetworkService
    
    init(localStorage: NewsResponseStorage, networkService: NetworkService) {
        self.localStorage = localStorage
        self.networkService = networkService
    }
    
    func getNews(for query: String, page: Int,
                 cached: @escaping (NewsModel) -> Void,
                 completion: @escaping (Result<NewsResponseDTO, Error>) -> Void) {
        
        let requestDTO = NewsRequestDTO(search: query, page: page)
        
        // fetch cached news
        localStorage?.getResponse(for: requestDTO, completion: { result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain(page: page))
            }
        })
         
        // fetch remote news
        self.networkService.getNews(request: requestDTO) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
                case .success(let responseDTO):
                    // Cache fetched news page
                    self.localStorage?.save(response: responseDTO, for: requestDTO)
                    
                    // return with fetched news
                    completion(.success(responseDTO))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
