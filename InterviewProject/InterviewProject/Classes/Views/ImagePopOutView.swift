//
//  ImagePopOutView.swift
//  InterviewProject
//
//  Created by Tom on 07/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

class ImagePopOutView: UIView {

	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var zoomImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		scrollView.delegate = self
		
	}
	
	func loadNib() -> ImagePopOutView {
		
		return Bundle.main.loadNibNamed("ImagePopOutView", owner: nil, options: nil)![0] as! ImagePopOutView
	}
	
	func addTapGesture() {
		
		//scrollView.contentSize = zoomImageView.size
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
		
		self.addGestureRecognizer(tap)
	}
	
	func setupScrollView() {
		guard let image = zoomImageView.image else {
			return
		}
		
		scrollView.contentSize = image.size
		scrollView.minimumZoomScale = 0.5
		scrollView.maximumZoomScale = 6.0
	}
	
	func dismiss() {
		self.removeFromSuperview()
	}
}

extension ImagePopOutView: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return zoomImageView
	}
	
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		print("Ended zooming")
	}
}
