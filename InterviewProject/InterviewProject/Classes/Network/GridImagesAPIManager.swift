//
//  GridImagesAPIManager.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import Foundation

class GridImagesAPIManager: BaseAPIManager {
	
	override func parse(response data: Dictionary<String, Any>) -> AnyObject? {
		var imagesDataModel = [GridImagesDataModel]()
		
		let images = data["pugs"] as? NSArray
		
		guard let urls = images else {
			return nil
		}
		for url in urls {
			imagesDataModel.append(GridImagesDataModel(with: url))
		}
		return imagesDataModel as AnyObject
	}
}
