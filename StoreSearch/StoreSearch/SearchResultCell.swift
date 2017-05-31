//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Norman Lopez on 5/23/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    var downloadTask: URLSessionDownloadTask?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255,blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
    
    func configure(for searchResult: SearchResult) {
        nameLabel.text = searchResult.name
        if searchResult.artistName.isEmpty {
            artistNameLabel.text =  NSLocalizedString("Unknown", comment: "Localized Uknown reference")
        } else {
            artistNameLabel.text = String(format: "%@ (%@)",searchResult.artistName, searchResult.kindForDisplay())
        }
        artworkImageView.image = UIImage(named: "Placeholder")
        if let smallURL = URL(string: searchResult.artworkSmallURL) {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }

}
