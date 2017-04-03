//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Ju on 2017/4/2.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit
import Twitter


let RecentSearckKey = "RecentSearckTextKey"

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var tweets = [[Tweet]]()
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            
            lastTwitterRequest = nil
            
            tweets.removeAll()
            tableView?.reloadData()
            
            searchForTweets()
            title = searchText
            
            // Store the recent searchs
            if let searchText = searchText {
                let userDefaults = UserDefaults()
                
                var recentSearchs = [String]()
                if let searchs = userDefaults.value(forKey: RecentSearckKey) {
                    recentSearchs = searchs as! [String]
                }
                if recentSearchs.count == 100 {
                    recentSearchs.removeLast()
                }
                recentSearchs.insert(searchText, at: 0)
                userDefaults.setValue(recentSearchs, forKey: RecentSearckKey)
                userDefaults.synchronize()
            }
        
        }
    }
    
    private func twittersRequest() -> Request? {
        if let query = searchText, !query.isEmpty {
            return Request(search: query, count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        refreshControl?.beginRefreshing()
        
        // may bug bug
        let height = refreshControl?.frame.size.height
        tableView?.setContentOffset(CGPoint(x: 0, y: -height!), animated: true)

        if let request = lastTwitterRequest?.newer ?? twittersRequest() {
            lastTwitterRequest = request
            
            DispatchQueue.global().async { [weak self] in
                request.fetchTweets({ newTweets in
                    DispatchQueue.main.async {
                        if request == self?.lastTwitterRequest {
                            self?.tweets.insert(newTweets, at: 0)
                            self?.tableView.insertSections([0], with: .fade)
                        }
                        self?.refreshControl?.endRefreshing()
                    }
                })
            }

        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        
        let tweet: Tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTweetDetail", sender: indexPath)
    }
        
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.identifier {
            if let indexPath = sender as? IndexPath,
                let tweetDetailVC = segue.destination.contents as? TweetDetailTableViewController {
                let tweet = tweets[indexPath.section][indexPath.row]
                tweetDetailVC.tweet = tweet
                tweetDetailVC.title = tweet.user.description
                tweetDetailVC.delegate = self
            }
        }
    }
    
}

extension TweetTableViewController: TweetDetailTableViewControllerDelegate {
    func mentionSelectedWithTweetDetail(_ tweetDetailViewController: TweetDetailTableViewController, mentionText text: String) {
        searchText = text
    }
}

extension UIViewController {
    
    var contents: UIViewController {
        if let contents = self as? UINavigationController {
            return contents.visibleViewController ?? self
        } else {
            return self
        }
    }
}
