//
//  ViewController.swift
//  StoreSearch
//
//  Created by Norman Lopez on 5/23/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import UIKit

struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let search = Search()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var landscapeViewController: LandscapeViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right:0)
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:TableViewCellIdentifiers.loadingCell)
        tableView.rowHeight = 80
        searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message:
            "There was an error reading from the iTunes Store. Please try again.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        switch newCollection.verticalSizeClass {
        case .compact:
            showLandscape(with: coordinator)
        case .regular, .unspecified:
            hideLandscape(with: coordinator)
        }
    }
    
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}

extension SearchViewController: UISearchBarDelegate {
    
    func performSearch() {
        search.performSearch(for: searchBar.text!,
                             category: segmentedControl.selectedSegmentIndex,
                             completion: { success in
            if !success {
                
                self.showNetworkError()
            }
            self.tableView.reloadData()
        })
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    //it is part of the UIBarPositioningDelegate protocol, which the UISearchBarDelegate protocol extends
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            destination.searchResult = search.searchResults[indexPath.row]
            
        }
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if search.isLoading {
            return 1
        }
        else if !search.hasSearched {
            return 0
        } else if search.searchResults.count == 0 {
            return 1
        } else {
            return search.searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if search.isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier:
                TableViewCellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        }
        
        if search.searchResults.count == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = search.searchResults[indexPath.row]
            cell.configure(for: searchResult)
            return cell
        }
    }
    
    
    
    func showLandscape(with coordinator:
        // 1
        UIViewControllerTransitionCoordinator) {
        guard landscapeViewController == nil else { return }
        // 2
        landscapeViewController = storyboard!.instantiateViewController(
            withIdentifier: "LandscapeViewController")
            as? LandscapeViewController
        if let controller = landscapeViewController {
            controller.search = search
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            view.addSubview(controller.view)
            addChildViewController(controller)
            coordinator.animate(alongsideTransition: { _ in
                controller.view.alpha = 1
                self.searchBar.resignFirstResponder()
                if self.presentedViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }, completion: { _ in
                controller.didMove(toParentViewController: self)
            })
        }
    }
    
    func hideLandscape(with coordinator:
        UIViewControllerTransitionCoordinator) {
        if let controller = landscapeViewController {
            controller.willMove(toParentViewController: nil)
            coordinator.animate(alongsideTransition: { _ in
                controller.view.alpha = 0
            }, completion: { _ in
                controller.view.removeFromSuperview()
                controller.removeFromParentViewController()
                self.landscapeViewController = nil
            })
        }
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    //Making sure proper cells can be selected. (nothing found) should not be selectable
    func tableView(_ tableView: UITableView,
                   willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if search.searchResults.count == 0 || search.isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    
    
    
}

