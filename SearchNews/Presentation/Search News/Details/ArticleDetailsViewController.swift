//
//  ArticleDetailsViewController.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import UIKit
import Kingfisher
class ArticleDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sourceButton: UIButton!
    
    static let identifier = "ArticleDetailsViewController"
    var article: NewsListItemViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fillArticleData()
    }
    
    //MARK: - Private
    private func fillArticleData() {
        guard let article = self.article else {
            return
        }
        
        title = article.title
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        dateLabel.text = article.date
        sourceButton.setTitle(article.source, for: .normal)
        authorLabel.text = article.author
        articleImageView.kf.setImage(with: URL(string: article.imageURL))
    }
    
    private func openURL(with urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(urlString): \(success)")
            })
        }
    }
    
    @IBAction func didClickSourceButton() {
        guard let article = self.article else {
            return
        }
        
        self.openURL(with: article.url)
    }
 
}
