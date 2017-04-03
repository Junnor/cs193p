//
//  TweetRecentsTableViewController.swift
//  Smashtag
//
//  Created by Ju on 2017/4/3.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit

class TweetRecentsTableViewController: UITableViewController {
    
    private var recentSearchs = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let searchs = UserDefaults().value(forKey: RecentSearckKey) {
            recentSearchs = searchs as! [String]
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recent", for: indexPath)

        let searchText = recentSearchs[indexPath.row]
        cell.textLabel?.text = searchText
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = recentSearchs[indexPath.row]
        if let navic = self.tabBarController?.viewControllers?[0] as? UINavigationController {
            navic.popToRootViewController(animated: false)
        }
        if let tweetSearchVC = self.tabBarController?.viewControllers?[0].contents as? TweetTableViewController {
            tweetSearchVC.searchText = text
            self.tabBarController?.selectedIndex = 0
        }
    }
}
