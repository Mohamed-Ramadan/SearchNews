//
//  DefaultNewsResponseStorage.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation
import CoreData
 
final class DefaultNewsResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

extension DefaultNewsResponseStorage: NewsResponseStorage {

    func getResponse(for request: NewsRequestDTO, completion: @escaping (Result<NewsResponseDTO?, CoreDataStorageError>) -> Void) {
 
    }

    func save(response: NewsResponseDTO, for requestDto: NewsRequestDTO) {
 
    }
} 
