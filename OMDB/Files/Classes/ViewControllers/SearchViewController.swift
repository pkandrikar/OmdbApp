//
//  SearchViewController.swift
//  OMDBAPI
//
//  Created by Piyush on 6/3/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    //**************************************************
    //MARK: - Properties
    //**************************************************
    @IBOutlet weak var searchTextField: UITextField!
    lazy var viewModel = SearchViewModel()
    
    //**************************************************
    //MARK: - Constants
    //**************************************************
    enum Constants {
        static let storyboard_main = "Main"
        static let searchResultViewController = "SearchResultViewController"
    }
    
    //**************************************************
    //MARK: - Methods
    //**************************************************
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTapped()
        return true
    }
    
    @IBAction func searchTapped() {
        if viewModel.isValidKeyword(searchTextField.text) {
            gotoSearchResultPage(keyword: searchTextField.text?.replacingOccurrences(of: " ", with: "+"))
        }else {
            showEmptySearchKeywordAlert()
        }
    }
    
    func gotoSearchResultPage(keyword: String?) {
        let storyboard = UIStoryboard(name: Constants.storyboard_main, bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: Constants.searchResultViewController) as? SearchResultViewController {
            self.view.endEditing(true)
            vc.searchKeyword = keyword
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showEmptySearchKeywordAlert() {
        let alert = UIAlertController(title: "No search keyword", message: "Please enter text to search and proceed.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        searchTextField.text = ""
    }

}
