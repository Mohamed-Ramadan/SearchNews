//
//  NewsLocalStorage.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation
 
protocol NewsResponseStorage {
    func getResponse(for request: NewsRequestDTO, completion: @escaping (Result<NewsResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: NewsResponseDTO, for requestDto: NewsRequestDTO)
}
