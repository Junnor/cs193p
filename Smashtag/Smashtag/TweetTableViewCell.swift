//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Ju on 2017/4/2.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        tweetUserLabel?.text = tweet?.user.description
        
        if let text = tweet?.text {
            let attiString = NSMutableAttributedString(string: text)
            if let hastags = tweet?.hashtags {
                for tag: Mention in hastags {
                    attiString.setAttributes([NSForegroundColorAttributeName: UIColor.red], range: tag.nsrange)
                }
            }
            if let mentionUrls = tweet?.urls {
                for url: Mention in mentionUrls {
                    attiString.setAttributes([NSForegroundColorAttributeName: UIColor.green], range: url.nsrange)
                }
            }
            if let mentionUser = tweet?.userMentions {
                for user: Mention in mentionUser {
                    attiString.setAttributes([NSForegroundColorAttributeName: UIColor.blue], range: user.nsrange)
                }
            }
            
            tweetTextLabel.attributedText = attiString
        }

        
        if let profileUrl = tweet?.user.profileImageURL {
            DispatchQueue.global().async { [weak self] in
                if let profileData = try? Data(contentsOf: profileUrl),
                    profileUrl == self?.tweet?.user.profileImageURL {
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: profileData)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
        
    }
}
