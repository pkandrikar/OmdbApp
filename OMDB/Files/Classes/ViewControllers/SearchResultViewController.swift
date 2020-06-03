//
//  SearchResultViewController.swift
//  OMDBAPI
//
//  Created by Piyush on 2/4/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit
import Foundation

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //**************************************************
    //MARK: - Properties
    //**************************************************
    let viewModel = SearchResultViewModel()
    var apiCalled: Bool = false
    var searchKeyword: String?
    
    var loadingView:UIActivityIndicatorView?
    
    @IBOutlet weak var table: UITableView!
    
    //**************************************************
    //MARK: - Constants
    //**************************************************
    enum Constants {
        static let searchResultCellIdentifier = "SearchResultCell"
        static let storyboard_main = "Main"
        static let searchDetailsVCIdentifier = "SearchDetailsViewController"
    }
    
    //**************************************************
    //MARK: - Methods
    //**************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTable()
        
        if let keyword = searchKeyword {
            SearchManager.sharedInstance.setSearchKeyword(keyword)
            viewModel.setPageNumber()
            table.reloadData()
        }
        
//        if viewModel.pageNumber == 1 {
            callApiToGetsearchResults()
//        }
    }
    
    func callApiToGetsearchResults() {
        apiCalled = true
        addLoadingView()
        viewModel.getSearchResult {[weak self] (data, response, error) in
            if let searchListData = data, error == nil {
                self?.viewModel.appendSearchResults(searchListData)
                DispatchQueue.main.async {
                    self?.plotsearchResultTable()
                    self?.removeLoadingView()
                }
            }else {
                DispatchQueue.main.async {
                    if let _error = error {
                        if self?.viewModel.getSearchResultsCount() == 0 {
                            self?.showError(_error as NSError)
                        }
                    }
                }
            }
            self?.apiCalled = false
        }
    }
    
    func addLoadingView() {
        loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        if let loadingView = loadingView {
            loadingView.startAnimating()
            view.addSubview(loadingView)
        }
    }
    func removeLoadingView() {
        if let loadingView = loadingView {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    func initTable() {
        let nib = UINib(nibName: Constants.searchResultCellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: Constants.searchResultCellIdentifier)
        
        table.dataSource = self
        table.delegate = self
        
        table.tableFooterView = UIView()
    }
    
    func plotsearchResultTable() {
        table.reloadData()
    }
    
    func openDetailsScreen(name: String, poster: String, movieID: String) {
        let storyboard = UIStoryboard(name: Constants.storyboard_main, bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: Constants.searchDetailsVCIdentifier) as? SearchDetailsViewController {
            vc.name = name
            vc.posterURL = poster
            vc.movieID = movieID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchResultViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSearchResultsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchResultCellIdentifier) as? SearchResultCell {
            let cellData = viewModel.getSearchResults()[indexPath.row]
            if let title = cellData.title, let year = cellData.year, let moviePoster = cellData.poster {
                cell.initWithData(title, year: year, thumbnail: moviePoster)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellData = viewModel.getSearchResults()[indexPath.row]
        if let name = cellData.title, let poster = cellData.poster, let movieID = cellData.imdbID {
            openDetailsScreen(name: name, poster: poster, movieID: movieID)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getSearchResultsCount() - 8 && !apiCalled {
//            getNewDataOnScroll()
        }
    }
    
    func getNewDataOnScroll() {
        apiCalled = true
        
        viewModel.getSearchResult { [weak self](data, response, error) in
            if let searchListData = data, error == nil {
                DispatchQueue.main.async {
                    self?.viewModel.appendSearchResults(searchListData)
                    self?.table.reloadData()
                }
                self?.apiCalled = false
            }else {
                DispatchQueue.main.async {
                    if let _error = error {
                        self?.showError(_error as NSError)
                    }
                }
            }
        }
    }
}

extension SearchResultViewController {
    func showError(_ error: NSError){
        let alert = UIAlertController(title: "Error!", message: error.userInfo["description"] as? String, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            if self.viewModel.getSearchResultsCount() == 0 {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
