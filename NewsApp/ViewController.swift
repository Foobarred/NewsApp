//
//  ViewController.swift
//  NewsApp
//
//  Created by Yassine on 2018-07-04.
//  Copyright © 2018 Yassine. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var articles: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()//inherits from super class viewDidLoad
        
        fetchArticles()
    }
    
    func fetchArticles(){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/everything?sources=mirror&apiKey=a9ea5ee627044bd98bdfe8daf6543d92")!)//brings in the api
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        if let urlToImage = articleFromJson["urlToImage"] as? String {
                            article.imageUrl = urlToImage                        }
                        if (articleFromJson["author"] as? String) != nil{
                            article.author = articleFromJson["author"] as? String ?? "Unknown Author"
                        }
                        if let desc = articleFromJson["description"] as? String{
                            article.desc = desc
                        }
                        if let title = articleFromJson["title"] as? String{
                            article.headline = title
                        }
                        if let url = articleFromJson["url"] as? String{
                            article.url = url
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {//manages execution of work items
                    self.tableview.reloadData()//reloads the news article in a copy of the cell it used before
                }
                
            } catch let error {
                print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.title.text = self.articles?[indexPath.item].headline
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.author.text = self.articles?[indexPath.item].author
        if let image = self.articles?[indexPath.item].imageUrl {
            cell.imgView.downloadImage(from:image)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
}

extension UIImageView {//Make an existing type conform to a protocol
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
