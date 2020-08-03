//
//  ViewController.swift
//  Hackernews
//
//  Created by nhn on 7/14/20.
//  Copyright © 2020 nhn. All rights reserved.
//


import UIKit
import Moya

class TopStoriesViewController: UIViewController {
 
    var from = 0, to = 19
    var storiesDataSource: StoriestDataSource?
    @IBOutlet weak var tableView: UITableView!
    let storyIdProvider = MoyaProvider<StoryIdAPI>()
    let storyProvider = MoyaProvider<StoryAPI>()
    var didReadId = [Any]()
    
    
    var listId = [Int]() {
        didSet {
            //  MARK: Fetch top story
            self.fetchStories(from: &self.from, to: &self.to)
        }
    }
    
    var listStory = [Story]() {
        didSet {
            storiesDataSource?.updateData(listStory: self.listStory, didReadId: didReadId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if userDefault.array(forKey: "DidReadId") != nil {
            didReadId = userDefault.array(forKey: "DidReadId")!
        } else {
            userDefault.set(didReadId, forKey: "DidReadId")
        }
        print(didReadId.count)
        
        
        self.showSpinner()
        tableView.backgroundColor = myBackgroundColor
        tableView.delegate = self
        storiesDataSource = StoriestDataSource(with: tableView, stories: [])
        tableView.dataSource = storiesDataSource
        
        //  MARK: Fetch id of top story
        // URLSession
//        let topStoriesIdRequest = IdRequest(typeStories: "topstories")
//                topStoriesIdRequest.getIdStories { [weak self] result in
//                     switch result {
//                     case .failure(let error):
//                         print(error)
//                     case .success(let output_ids):
//                        self?.listId = output_ids
//                        print("Fetch id success")
//                     }
//                 }
        
        // Alamofire
//        let topStoriesIdRequest = StoriesIDServices()
//        topStoriesIdRequest.getlistID(typeStories: "topstories")
//        topStoriesIdRequest.completionHandler { [weak self] (listIdRes, status, message) in
//            if status {
//                guard let _listIdRes = listIdRes else {return}
//                self?.listId = _listIdRes
//            }
//        }
        
        // Moya
        storyIdProvider.request(.getId(storyType: "topstories")) { (result) in
            switch result {
            case .success(let response):
                self.listId = try! JSONDecoder().decode([Int].self, from: response.data)
//                self.fetchStories(from: &self.from, to: &self.to)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func clearHistoryTapped(_ sender: Any) {

        didReadId = []
        userDefault.set(didReadId, forKey: "DidReadId")
    }
    
    func fetchStories( from:inout Int, to:inout Int) {
        
        if from > listId.count - 1 {
            return
        }
        if to > listId.count-1 {
            to = listId.count-1
        }
        
//        let storyService = StoryService()
        for i in from...to {
            // URLSession
//            let storyRequest = StoryRequest(id: self.listId[i])
//            storyRequest.getStory { [weak self] result in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let outputStory):
//                    self?.listStory.append(outputStory)
//                }
//            }
            
            // Alamofire
//            storyService.getStoryFromId(id: self.listId[i])
//            storyService.completionHandler { (story, status, message) in
//                if status {
//                    guard let _story = story else {return}
//                    self.listStory.append(_story)
//                }
//            }
            
            // Moya            
            storyProvider.request(.getStory(id: self.listId[i])) { (result) in
                switch result {
                case .success(let res):
                    do {
                        let story = try JSONDecoder().decode(Story.self, from: res.data)
                        self.listStory.append(story)
                    } catch {
                        print("Can not process data")
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        from += 20
        to += 20
        self.removeSpinner()
    }
}

extension TopStoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
            fetchStories(from: &from, to: &to)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = listStory[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ReadStoryViewController") as! ReadStoryViewController
        vc.urlString = story.url
        print(story.id)
        

        let didRead = didReadId.contains { el in
            if el as! Int == story.id {
                return true
            } else {
                return false
            }
        }
//        var didRead = false
//        for id in didReadId {
//            if story.id == (id as! Int) {
//                didRead = true
//                break
//            }
//        }
        if didRead == false {
            didReadId.append(story.id)
            userDefault.set(didReadId, forKey: "DidReadId")
        }
        
        print("#############################")
        print(didReadId.count)
        print("#############################")
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
