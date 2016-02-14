//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var businesses: [Business]!
  
  @IBOutlet weak var tableView: UITableView!
  
  var searchController: UISearchController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    self.navigationItem.titleView = searchController.searchBar
    searchController.searchBar.delegate = self
    searchController.hidesNavigationBarDuringPresentation = false
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    
    Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      
      self.tableView.reloadData()
    })
    
    
    // Set up Infinite Scroll loading indicator
    let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
    loadingMoreView = InfiniteScrollActivityView(frame: frame)
    loadingMoreView!.hidden = true
    tableView.addSubview(loadingMoreView!)
    
    var insets = tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    tableView.contentInset = insets

    
    /* Example of Yelp search with more search options specified
    Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
    self.businesses = businesses
    
    for business in businesses {
    print(business.name!)
    print(business.address!)
    }
    }
    */
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if businesses != nil {
      return businesses.count
    }
    else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell

    cell.business = businesses[indexPath.row]
    
    return cell
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  // MARK Scroll view support
  
  var isMoreDataLoading = false
  var loadingMoreView: InfiniteScrollActivityView!
  
}

extension BusinessesViewController: UISearchResultsUpdating, UISearchBarDelegate {
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    if let searchText = searchController.searchBar.text {
      Business.searchWithTerm(searchText, sort: .BestMatched, categories: ["restaurants"], deals: nil, completion: { (businesses, error) -> Void in
        self.businesses = businesses
        self.tableView.reloadData()
      })
    }
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchController.searchBar.text = ""
    self.tableView.reloadData()
  }
  
}

extension BusinessesViewController: UIScrollViewDelegate {
  
  func loadMoreData() {
    
    Business.searchWithTerm("Thai", sort: nil, categories: nil, deals: nil, limit:20, offset: businesses.count) { (businesses, error) -> Void in
      // ... Use the new data to update the data source ...
      let currentCount = self.businesses!.count
      self.businesses!.appendContentsOf(businesses)
      var indices: [NSIndexPath] = []
      for i in 0..<businesses.count {
        indices.append(NSIndexPath(forRow: currentCount + i, inSection: 0))
      }
      self.tableView.insertRowsAtIndexPaths(indices, withRowAnimation: .Automatic)
      
      self.loadingMoreView.stopAnimating()
      
      // Update flag
      self.isMoreDataLoading = false
    }
  }
  
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.height * 2
      
      if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
        isMoreDataLoading = true
        
        // Update position of loadingMoreView, and start loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView.frame = frame
        loadingMoreView.startAnimating()
        
        loadMoreData()
      }
    }
  }

}
