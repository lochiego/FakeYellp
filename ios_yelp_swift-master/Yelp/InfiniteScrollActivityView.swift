//
//  InfiniteScrollActivityView.swift
//  Instagram
//
//  Created by Eric Gonzalez on 2/3/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

class InfiniteScrollActivityView: UIView {
  
  var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
  
  static let defaultHeight:CGFloat = 60.0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupActivityIndicator()
  }
  
  override init(frame aRect: CGRect) {
    super.init(frame: aRect)
    setupActivityIndicator()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
  }
  
  func setupActivityIndicator() {
    activityIndicatorView.hidesWhenStopped = true
    self.addSubview(activityIndicatorView)
  }
  
  func stopAnimating() {
    self.activityIndicatorView.stopAnimating()
    self.hidden = true
  }
  
  func startAnimating() {
    self.hidden = false
    self.activityIndicatorView.startAnimating()
  }
}
