//
//  ViewController.swift
//  NewsFeedChallenge
//
//  Created by Kunal Chhabra on 19/05/21.
//

import UIKit

class NewsFeedViewController: UIViewController {

    //MARK: - properties - 
    let reuseIdentifier = "MyTableViewCell"
    var myCell = NewsFeedTableViewCell()
    var refreshControl = UIRefreshControl()
    private var viewModel = NewsFeedViewModel()
    
    //MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadNewsFeedData()
        
        newsFeedtableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        newsFeedtableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        headingTitle.translatesAutoresizingMaskIntoConstraints = false
        newsFeedtableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(headingTitle)
        self.view.addSubview(newsFeedtableView)
        
        headingTitle.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        headingTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        headingTitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        headingTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        newsFeedtableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newsFeedtableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        newsFeedtableView.topAnchor.constraint(equalTo: self.headingTitle.bottomAnchor, constant: 1).isActive = true
        newsFeedtableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 1).isActive = true
    }
    
    //MARK: - Service call method -
    private func loadNewsFeedData() {
        viewModel.fetchNewsFeedData { [weak self] in
            self?.newsFeedtableView.dataSource = self
            self?.newsFeedtableView.delegate = self
            self?.newsFeedtableView.reloadData()
        }
    }
    
    //MARK: - Refresh Screen method -
    @objc func pullToRefresh(sender: UIRefreshControl){
        loadNewsFeedData()
        sender.endRefreshing()
        newsFeedtableView.reloadData()
    }
    
//    func tableViewSetup(){
//        newsFeedtableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
//    }
    
    //MARK: - Adding TableView & Head Title Label programatically -
    let newsFeedtableView : UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let headingTitle : UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.text = "Just In"
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.medium)
        return label
    }()
    
}

//MARK: - TableView DataSource Methods -
extension NewsFeedViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        myCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewsFeedTableViewCell
        myCell.contentView.backgroundColor = .systemGray5
        tableView.separatorStyle = .none
        let news = viewModel.cellForRowAt(indexPath: indexPath)
        myCell.setCellWithValuesOf(news)
        
        return myCell
    }
}

//MARK: - TableView Delegate Methods -
extension NewsFeedViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsTitleHeight = myCell.newsTitle.frame.height
        let totalHeight = (350 + newsTitleHeight)
        return totalHeight
    }
}

