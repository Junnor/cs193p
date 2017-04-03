//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Ju on 2017/4/2.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit
import Twitter

protocol TweetDetailTableViewControllerDelegate: class {
    func mentionSelectedWithTweetDetail(_ tweetDetailViewController: TweetDetailTableViewController, mentionText text: String)
}

class TweetDetailTableViewController: UITableViewController {
    
    private enum TweetMention: Int {
        case images = 0
        case hastags
        case urls
        case userMentions
    }
    
    weak var delegate: TweetDetailTableViewControllerDelegate?
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mention = TweetMention(rawValue: section) {
            switch mention {
            case TweetMention.images: return tweet?.media.count ?? 0
            case TweetMention.hastags: return tweet?.hashtags.count ?? 0
            case TweetMention.userMentions: return tweet?.userMentions.count ?? 0
            case TweetMention.urls: return tweet?.urls.count ?? 0
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return imageCellWithTableView(tableView, forRowAt: indexPath)
        } else {
            return mentionTextCellWithTableView(tableView, forRowAt: indexPath)
        }
    }
    
    private func imageCellWithTableView(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetImage", for: indexPath)
        if let imageCell = cell as? TweetImageTableViewCell,
            let media: Array<MediaItem> = tweet?.media {
            let mediaItem = media[indexPath.section]
            imageCell.imageUrl = mediaItem.url
        }
        return cell
    }
    
    private func mentionTextCellWithTableView(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetMention", for: indexPath)
        if let mention = TweetMention(rawValue: indexPath.section) {
            var text: String?
            switch mention {
            case .hastags: text = tweet?.hashtags[indexPath.row].keyword ?? nil
            case .userMentions: text = tweet?.userMentions[indexPath.row].keyword ?? nil
            case .urls: text = tweet?.urls[indexPath.row].keyword ?? nil
            default: break
            }
            cell.textLabel?.text = text
        }
        return cell
    }
    
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let mention = TweetMention(rawValue: section) {
            switch mention {
            case .images: return tweet?.media.count != 0 ? "Media" : nil
            case .hastags: return tweet?.hashtags.count != 0 ? "Hastags" : nil
            case .userMentions: return tweet?.userMentions.count != 0 ? "UserMentions" : nil
            case .urls: return tweet?.urls.count != 0 ? "Urls" : nil
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let media = tweet?.media {
                let width = view.bounds.width
                let mediaItem = media[indexPath.row]
                let ratio = mediaItem.aspectRatio
                return width / CGFloat(ratio)
            } else {
                return UITableViewAutomaticDimension
            }
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mention = TweetMention(rawValue: indexPath.section) {
            switch mention {
            case .images:
                performSegue(withIdentifier: "ShowTweetImage", sender: indexPath)
            case .hastags:
                let hastags = tweet?.hashtags
                let tag = hastags![indexPath.row]
                self.delegate?.mentionSelectedWithTweetDetail(self, mentionText: tag.keyword)
                let _ = navigationController?.popViewController(animated: true)
            case .userMentions:
                let userMentions = tweet?.userMentions
                let userMention = userMentions![indexPath.row]
                self.delegate?.mentionSelectedWithTweetDetail(self, mentionText: userMention.keyword)
                let _ = navigationController?.popViewController(animated: true)
            case .urls:
                let keyword = tweet?.urls[indexPath.row].keyword
                let url = URL(string: keyword!)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    print("Method open(url) not available")
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil {
            if let indexPath = sender as? IndexPath,
                let imageVC = segue.destination.contents as? ImageViewController {
                let mediaItem: MediaItem = (tweet?.media[indexPath.row])!
                imageVC.imageURL = mediaItem.url
                imageVC.title = "TweetImage"
            }
        }
    }
}
