//
//  SearchNewsViewModel.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation
 
enum SearchNewsViewModelLoading {
    case fullScreen
    case nextPage
    case none
}

protocol SearchNewsViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func didSelectItem(at index: Int) -> Article
}

class SearchNewsViewModel: SearchNewsViewModelInput {
    
    private(set) var newsUseCase: SearchNewsUseCase
    var pages: [NewsModel] = [] {
        didSet{
            self.articlesCompletionHandler()
        }
    }
    private(set) var searchKeyword = ""
    private(set) var totalArticles = 1
    private(set) var pageSize = 20
    private(set) var currentPage = 0
    var hasMorePages: Bool { (currentPage * pageSize) < totalArticles }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
     
    private(set) var loading: SearchNewsViewModelLoading = .none {
        didSet {
            self.loadingCompletionHandler(loading)
        }
    }
     
    var error:(_ errMsg: String)->() = {_ in}
    var articlesCompletionHandler: ()->() = {}
    var loadingCompletionHandler:(_ loading: SearchNewsViewModelLoading) -> () = {_ in}
    
    //MARK: - init
    init(newsUseCase: SearchNewsUseCase) {
        self.newsUseCase = newsUseCase
    }
    
    //MARK:- Private
    private func appendPage(_ page: NewsModel) {
        totalArticles = page.totalResults
        currentPage = page.page
        
        pages = pages
            .filter { $0.page != page.page }
            + [page]
    }
     
    private func load(newsQuery: NewsQuery, loading: SearchNewsViewModelLoading) {
        
        self.loading = loading
        let request = SearchNewsUseCaseRequestValue(query: newsQuery.query, page: nextPage)
        
        newsUseCase.fetchNews(requestValue: request, cached: appendPage) { (result) in
            self.loading = .none
            
            switch result {
            case .success(let clientsPage):
                self.appendPage(clientsPage)
            case .failure(let error):
                self.error(error.localizedDescription)
            }
        }
    }
   
    private func resetPages() {
        currentPage = 0
        totalArticles = 1
        pages.removeAll()
    }
    
    func update(newsQuery: NewsQuery) {
        resetPages()
        self.searchKeyword = newsQuery.query
        load(newsQuery: newsQuery, loading: .fullScreen)
    }
    
    func getViewModel(for index: Int) -> NewsListItemViewModel {
        return NewsListItemViewModel.init(article: self.pages.articles[index])
    }
}


// MARK: - INPUT. View event methods

extension SearchNewsViewModel {
    func viewDidLoad() {}
    
    func didCancelSearch() {}
    
    func didSelectItem(at index: Int) -> Article {
        return pages.articles[index]
    }
    
    func didLoadNextPage() {
        guard hasMorePages, self.loading == .none else {
            self.loading = .none
            return
        }
        load(newsQuery: .init(query: searchKeyword), loading: .nextPage)
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(newsQuery: NewsQuery(query: query))
    }
}

// MARK: - Private

extension Array where Element == NewsModel {
    var articles: [Article] { flatMap { $0.articles } }
}


