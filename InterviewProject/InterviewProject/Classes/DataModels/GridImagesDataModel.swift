//
//  GridImagesDataModel.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import Foundation

class GridImagesDataModel {
	
	var imageURL: String?
	
	init(with data: Any) {
		imageURL = data as? String
	}
	
	private func getMessages(from data: Array<Any>?) -> [MessageDataModel]? {
		guard let messagesArray = data else {
			return nil
		}
		var messages = [MessageDataModel]()
		for item in messagesArray {
			guard let message = item as? Dictionary<String, Any> else {
				continue
			}
			messages.append(MessageDataModel(with: message))
		}
		return messages
	}
}


