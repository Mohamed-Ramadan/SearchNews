//
//  NetworkService.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//
 
import Foundation

protocol NetworkService {
    func getNews(request: NewsRequestDTO , completion:  @escaping (Result<NewsResponseDTO, Error>) -> Void)
}

class URLSessionNetworkService: NetworkService {
     
    func getNews(request: NewsRequestDTO, completion: @escaping (Result<NewsResponseDTO, Error>) -> Void) {
        
        let urlString = Constants.serverURl + "q=\(request.search)&page=\(request.page)&apiKey=\(Constants.apiKey)"
        guard let urlEncodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: urlEncodedString) else {
            print("Wrong URL!: \(urlString)")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
  
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "Data not valid or empty", code: 402, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                // parse json data to model items
                let response = try JSONDecoder().decode(NewsResponseDTO.self, from: data)
                
                completion(.success(response))
            } catch let error { 
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
