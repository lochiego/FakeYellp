//
//  BusinessCell.swift
//  Yelp
//
//  Created by Eric Gonzalez on 2/8/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

  @IBOutlet weak var thumbImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var ratingView: UIImageView!
  @IBOutlet weak var reviewsLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  var business: Business! {
    didSet {
      titleLabel.text = business.name
      thumbImageView.setImageWithURL(business.imageURL!)
      ratingView.setImageWithURL(business.ratingImageURL!)
      if let reviews = business.reviewCount {
        reviewsLabel.text = "\(reviews) Reviews"
      }
      else {
        reviewsLabel.text = nil
      }
      addressLabel.text = business.address
      categoriesLabel.text = business.categories
      distanceLabel.text = business.distance
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      thumbImageView.layer.cornerRadius = 5
      thumbImageView.clipsToBounds = true
      
      titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
    }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
