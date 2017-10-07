//
//  GridimageCollectionViewCell.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit



class GridimageCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
	
	@IBOutlet weak var gridImageView: UIImageView!
	
	var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()

	}
	
	func setupCell(with imageDataModel: GridImagesDataModel?, at indexPath: IndexPath) {
		self.indexPath = indexPath
		gridImageView.image = nil
		guard let url = imageDataModel?.imageURL else {
			return
		}
		gridImageView.imageFromURL(urlString: url)
	}
}
