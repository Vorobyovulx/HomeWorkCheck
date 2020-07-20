//
//  NewsTabViewController.swift
//  AppForVK
//
//  Created by Mad Brains on 01.07.2020.
//  Copyright © 2020 Семериков Михаил. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class NewsTabViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    let newsService = VkNewsService()
    var vkNews: VkNews?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
//        newsService.loadVkNewsFeed(
//            completion: { [weak self] news, error in
//                guard let _ = error else {
//                    print(news?.items.count)
//                    self?.vkNews = news
//                    self?.tableView.reloadData()
//                    return
//                }
//
//                print("Some error")
//            }
//        )
        
        firstly {
            newsService.loadVkNewsFeedPromise()
        }
        .done { [weak self] news in
            self?.vkNews = news
            self?.tableView.reloadData()
        }
        .catch { error in
            
        }
//        //newsService.loadVkNewsFeedPromise().
//        
//        // WHEN
//        
//        var result1: Promise<VkNews> = self.newsService.loadVkNewsFeedPromise()
//        var result2: Promise<VkNews> = self.newsService.loadVkNewsFeedPromise()
//        
//        let group = DispatchGroup()
//
//        let work1 = DispatchQueue.global().async(group: group) {
//            result1 = self.newsService.loadVkNewsFeedPromise()
//        }
//        
//        let work2 = DispatchQueue.global().async(group: group) {
//            result2 = self.newsService.loadVkNewsFeedPromise()
//        }
//    
//        group.notify(queue: .main) {
//           print("Finish")
//        }
//        
//        firstly {
//            when(fulfilled: self.newsService.loadVkNewsFeedPromise(), self.newsService.loadVkNewsFeedPromise())
//        }
//        .done { result1, result2 in
//            //…
//        }
        
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "NewsTabCell", bundle: nil), forCellReuseIdentifier: "NewsTabCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
//
//    func getIcon(named iconName: String) -> Promise<UIImage> {
//        return Promise<UIImage> {
//            getFile(named: iconName, completion: $0.resolve)// 1
//        }
//            .recover { _ in // 2
//                self.getIconFromNetwork(named: iconName)
//        }
//    }
//
//    func getFile(named: String, completion: Result<UIImage?>) {
//        completion()
//    }
//
//    func getIconFromNetwork(named: String) -> Promise<UIImage> {
//
//    }
    
}

extension NewsTabViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
}

extension NewsTabViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vkNews?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTabCell", for: indexPath) as? NewsTabCell
 
        guard let uCell = cell, let uVkNews = vkNews else {
            print("Error with news cell")
            return UITableViewCell()
        }
    
        let sourceId = uVkNews.items[indexPath.row].postSource_id
    
        let ownerGroup = uVkNews.groups.filter { $0.ownerId == -sourceId }.first
        let ownerUser = uVkNews.profiles.filter { $0.ownerId == sourceId }.first
        
        let owner = ownerGroup == nil ? ownerUser : ownerGroup
        
        uCell.configure(with: vkNews?.items[indexPath.row], owner: owner)
        
        return uCell
    }
    
    
}
