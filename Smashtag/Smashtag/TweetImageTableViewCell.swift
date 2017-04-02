//
//  TweetImageTableViewCell.swift
//  Smashtag
//
//  Created by Ju on 2017/4/2.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit

class TweetImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var imageUrl: URL? { didSet { updateUI() } }
    
    private func updateUI() {
        
        if let url = imageUrl {
            spinner.startAnimating()
            
            DispatchQueue.global().async { [weak self] in
                if let imageData = try? Data(contentsOf: url), url == self?.imageUrl {
                    DispatchQueue.main.async {
                        self?.tweetImageView.image = UIImage(data: imageData)
                        self?.spinner.stopAnimating()
                    }
                } else {
                    self?.tweetImageView.image = nil
                    self?.spinner.stopAnimating()
                }
            }
        }
    }
}
