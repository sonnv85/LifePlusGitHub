//
//  BaseTableVC.swift
//  Rental App
//
//  Created by Ninh Vo on 8/19/16.
//  Copyright © 2016 IdeaBox. All rights reserved.
//

import MJRefresh

class BaseTableVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func customUI() {
        super.customUI()
        configTableView()
    }
    
    deinit {
        tableView = nil
    }
    
    func reloadData(reload: Bool){
    }
    
    func addPullToRefresh() {
        let header = MJRefreshNormalHeader()
        header.refreshingBlock = {
            self.reloadData(reload: true)
        }
        header.lastUpdatedTimeLabel.isHidden = true
        header.setTitle("Pull down to refresh", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
        header.beginRefreshing()
        self.tableView.mj_header = header
    }
    
    func triggerPullToRefresh() {
        self.tableView.mj_header.beginRefreshing()
    }
    
    func addLoadMore() {
        let footer = MJRefreshAutoNormalFooter()
        footer.refreshingBlock = {
            self.reloadData(reload: false)
        }

        footer.setTitle("Click or drag up to refresh", for: .idle)
        footer.setTitle("No more data", for: .noMoreData)
        footer.setTitle("Loading more ...", for: .refreshing)
        self.tableView.mj_footer = footer
    }
    
    func endRefresh(reloadData: Bool = true) {
        if reloadData {
            tableView.reloadData()
        }
        if self.tableView.mj_footer.state == .refreshing{
            self.tableView.mj_footer.endRefreshing()
        }
        else if self.tableView.mj_header.state == .refreshing {
            self.tableView.mj_header.endRefreshing()
        }
    }
    
}

extension BaseTableVC {
    func configTableView() {
        if tableView == nil {
            tableView = UITableView(frame: view.bounds, style: .plain)
            tableView.backgroundColor = UIColor.clear
            view.addSubview(tableView)
            //tableView.autoPinEdgesToSuperviewEdges()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BaseCell.classForCoder(), forCellReuseIdentifier: BaseCellId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseCellId) as! BaseCell
        return cell
    }
    
    func noResultCell(text: String) -> BaseCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseCellId) as! BaseCell
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = text
        return cell
    }
}
