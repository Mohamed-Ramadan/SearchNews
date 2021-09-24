//
//  NewsListTableViewCell.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {

    static let identifier = "NewsListTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    static func nib() -> UINib {
        let nib = UINib(nibName: NewsListTableViewCell.identifier, bundle: nil)
        return nib
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.borderColor = UIColor.lightGray.cgColor
        self.cardView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCellWithArticle(_ articleViewModel: NewsListItemViewModel) {
        titleLabel.text = articleViewModel.title
        subTitleLabel.text = articleViewModel.subTitle
    }
}
