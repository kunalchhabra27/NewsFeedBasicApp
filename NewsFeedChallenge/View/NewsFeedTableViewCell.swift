//
//  NewsFeedTableViewCell.swift
//  NewsFeedChallenge
//
//  Created by Kunal Chhabra on 19/05/21.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    //MARK: - properties - 
    private var urlString: String = ""
    
    // Setup news feed values
    func setCellWithValuesOf(_ news:DataItems) {
        updateUI(title: news.title, publishedDate: news.pubDate, poster: news.thumbnail)
    }
    
    // Update the UI Views
    private func updateUI(title: String?, publishedDate: String?, poster: String?)
    {
        self.newsTitle.text = title
        self.dateLabel.text = convertDateFormater(publishedDate)

        let splitThumbnailString = poster?.split(separator: "?")
        guard let posterString = splitThumbnailString?[0] else {return}
        urlString = String(posterString)

        guard let posterImageURL = URL(string: urlString) else {
            self.newsImage.image = UIImage(named: "noImageAvailable")
            return
        }

        // Before we download the image we clear out the old one
        self.newsImage.image = nil
        getImageDataFrom(url: posterImageURL)
    }
    
    // MARK: - Get image data -
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.newsImage.image = image
                }
            }
        }.resume()
    }
    
     //MARK: - Convert date format -
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let parentContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    let newsImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let newsTitle : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
        return label
    }()
    
    let separatorLine : UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Adding constraints programatically to a tableView cell components -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(parentContainerView)
        self.parentContainerView.addSubview(newsImage)
        self.parentContainerView.addSubview(newsTitle)
        self.parentContainerView.addSubview(separatorLine)
        self.parentContainerView.addSubview(dateLabel)
        
        parentContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        parentContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        parentContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        parentContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
        
        newsImage.leadingAnchor.constraint(equalTo: self.parentContainerView.leadingAnchor).isActive = true
        newsImage.trailingAnchor.constraint(equalTo: self.parentContainerView.trailingAnchor).isActive = true
        newsImage.topAnchor.constraint(equalTo: self.parentContainerView.topAnchor).isActive = true
        newsImage.heightAnchor.constraint(equalTo: self.parentContainerView.heightAnchor, multiplier: 0.6).isActive = true
        
        newsTitle.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor, constant: 8).isActive = true
        newsTitle.trailingAnchor.constraint(equalTo: self.parentContainerView.trailingAnchor, constant: -8).isActive = true
        newsTitle.topAnchor.constraint(equalTo: self.newsImage.bottomAnchor, constant: 8).isActive = true
        newsTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        separatorLine.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor, constant: 8).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: self.parentContainerView.trailingAnchor, constant: -8).isActive = true
        separatorLine.topAnchor.constraint(equalTo: self.newsTitle.bottomAnchor, constant: 8).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor, constant: 8).isActive = true
        dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.separatorLine.bottomAnchor, constant: 8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
