//
//  SearchResultViewController.swift
//  OMDBAPI
//
//  Created by Piyush on 6/3/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit
import Foundation

class SearchResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //**************************************************
    //MARK: - Properties
    //**************************************************
    let viewModel = SearchResultViewModel()
    var apiCalled: Bool = false
    var searchKeyword: String?
    
    var loadingView:UIActivityIndicatorView?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
            collectionView.reloadData()
        }
        
        callApiToGetsearchResults()
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
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.searchResultCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func plotsearchResultTable() {
        collectionView.reloadData()
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSearchResultsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.searchResultCellIdentifier, for: indexPath) as? SearchResultCell {
            let cellData = viewModel.getSearchResults()[indexPath.row]
            if let title = cellData.title, let year = cellData.year, let moviePoster = cellData.poster {
                cell.initWithData(title, year: year, thumbnail: moviePoster)
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = viewModel.getSearchResults()[indexPath.row]
        if let name = cellData.title, let poster = cellData.poster, let movieID = cellData.imdbID {
            openDetailsScreen(name: name, poster: poster, movieID: movieID)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 20)/2;
        let cellHeight = cellWidth * 1.55 + 116
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getSearchResultsCount() - 8 && !apiCalled {
            getNewDataOnScroll()
        }
    }
    
    func getNewDataOnScroll() {
        apiCalled = true
        
        viewModel.getSearchResult { [weak self](data, response, error) in
            if let searchListData = data, error == nil {
                DispatchQueue.main.async {
                    self?.viewModel.appendSearchResults(searchListData)
                    self?.collectionView.reloadData()
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
