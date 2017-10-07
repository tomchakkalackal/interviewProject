//
//  Extensions.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

extension String {
	
	func smartDateText() -> String? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
		guard let date = dateFormatter.date (from: self) else {
			return nil
		}
  
		dateFormatter.dateFormat = "EEE MMM dd HH:mm"
		return dateFormatter.string(from: date)
	}
}

extension UIImageView {
	
	func imageFromURL(urlString: String) {
		let cachedImage = PhotosManager.shared.cache.filter({$0.identifier == urlString})
		if cachedImage.isEmpty {
			guard let imageURL = URL(string: urlString) else {
				return
			}
			URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) -> Void in
				if error != nil {
					print(error ?? "error")
					return
				}
				DispatchQueue.main.async(execute: { () -> Void in
					let image = UIImage(data: data!)
					PhotosManager.shared.cache.append(ImageCache(with: image, identifier: urlString))
					self.image = image
				})
			}).resume()
		} else {
			self.image = cachedImage[0].image
		}
	}
}

extension UIView {
	
	func toast(with message: String) {
		let containerView = UIView()
		containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
		containerView.alpha = 1.0
		containerView.layer.cornerRadius = 3
		
		let toastLabel = UILabel()
		toastLabel.backgroundColor = UIColor.clear
		toastLabel.textColor = UIColor.white
		toastLabel.numberOfLines = 0
		toastLabel.textAlignment = .center
		toastLabel.font = UIFont(name:"ProximaNova-Regular",size: (12.0))
		toastLabel.text = message
		toastLabel.clipsToBounds  =  true
		
		self.addSubview(containerView)
		containerView.addSubview(toastLabel)
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		toastLabel.translatesAutoresizingMaskIntoConstraints = false
		
		//constraints to hold containerView to view
		self.addConstraint(NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal,
		                                      toItem: self, attribute: .bottom, multiplier: 1, constant: -25.0))
		self.addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal,
		                                      toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
		self.addConstraint(NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal,
		                                      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 211.0))
		//constraints to hold label inside the container view.
		containerView.addConstraint(NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -10))
		containerView.addConstraint(NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 10))
		containerView.addConstraint(NSLayoutConstraint(item: toastLabel, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 10))
		containerView.addConstraint(NSLayoutConstraint(item: toastLabel, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: -10))
		
		UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseInOut, animations: {
			containerView.alpha = 0.0
		}, completion: {(isCompleted) in
			toastLabel.removeFromSuperview()
		})
	}
}
