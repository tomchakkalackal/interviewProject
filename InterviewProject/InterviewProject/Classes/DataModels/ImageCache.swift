//
//  ImageCache.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
	
	var image: UIImage?
	var identifier: String? //preferably the url for the image
	
	init(with image: UIImage?, identifier: String?) {
		self.image = image
		self.identifier = identifier
	}
}
