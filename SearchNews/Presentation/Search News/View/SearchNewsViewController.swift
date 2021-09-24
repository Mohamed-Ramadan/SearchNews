//
//  SearchNewsViewController.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import UIKit

class SearchNewsViewController: UIViewController {
     
    static let identifier = "SearchNewsViewController"
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
     
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    var fullPageLoadingSpinner: UIActivityIndicatorView?
    var viewModel: SearchNewsViewModel!
    
    private lazy var searchNewsUseCase: SearchNewsUseCase = {
        let newsResponseStorage: NewsResponseStorage = DefaultNewsResponseStorage()
        let networkService: NetworkService = URLSessionNetworkService()
        let newsRepository: SearchNewsRepository = DefaultSearchNewsRepository(localStorage: newsResponseStorage, networkService: networkService)
        return DefaultSearchNewsUseCase(newsRepository: newsRepository)
    }()
     
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
        bindViewModel()
        loadData()
    }
    
    //MARK: - Private Methods
    private func loadData() {
        self.searchTextField.text = "apple"
        self.viewModel.update(newsQuery: .init(query: "apple"))
    }
    
    private func bindViewModel() {
        self.viewModel = SearchNewsViewModel(newsUseCase: searchNewsUseCase)
         
        self.viewModel.articlesCompletionHandler = {
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
        
        self.viewModel.loadingCompletionHandler = { [weak self] in
            guard let self = self else {
                return
            }
             
            self.updateLoading($0)
        }
        
        self.viewModel.error = { errorMsg in
            self.showAlert(with: errorMsg)
        }
    }
     
    private func updateLoading(_ loading: SearchNewsViewModelLoading) {
        DispatchQueue.main.async {
            switch loading {
                case .fullScreen: self.handleFullPageLoading(isAnimating: true)
                case .nextPage, .none: self.handleFullPageLoading(isAnimating: false)
            }
            
            self.updateTableViewFooterLoading(loading)
        } 
    }
    
    private func handleFullPageLoading(isAnimating: Bool) {
        if isAnimating {
            fullPageLoadingSpinner?.removeFromSuperview()
            fullPageLoadingSpinner = self.makeActivityIndicator(size: .init(width: self.view.frame.width, height: 44))
            self.view.addSubview(fullPageLoadingSpinner!)
            fullPageLoadingSpinner?.startAnimating()
        } else {
            fullPageLoadingSpinner?.removeFromSuperview()
        }
    }
    
    func updateTableViewFooterLoading(_ loading: SearchNewsViewModelLoading) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = newsTableView.makeActivityIndicator(size: .init(width: newsTableView.frame.width, height: 44))
            newsTableView.tableFooterView = nextPageLoadingSpinner
            case .fullScreen, .none:
                newsTableView.tableFooterView = nil
        }
    }
    
    private func setupUI () {
        self.title = "News"
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupTableView() {
        self.newsTableView.register(NewsListTableViewCell.nib(), forCellReuseIdentifier: NewsListTableViewCell.identifier)
        
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        self.newsTableView.separatorStyle = .none
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if let text = textField.text {
            self.viewModel.update(newsQuery: .init(query: text))
        }
    }
    
    @IBAction func didClickSearchButton() {
        if let text = searchTextField.text {
            self.viewModel.update(newsQuery: .init(query: text))
        }
    }
    
}

extension SearchNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.articlesCellsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.identifier, for: indexPath) as? NewsListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configureCellWithArticle(self.viewModel.articlesCellsViewModel[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.viewModel.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.articlesCellsViewModel.count-2 {
            self.viewModel.didLoadNextPage()
        }
    }
}

