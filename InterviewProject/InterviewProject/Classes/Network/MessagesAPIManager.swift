//
//  MessagesAPIManager.swift
//  InterviewProject
//
//  Created by Tom on 05/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import Foundation

class MessagesAPIManager: BaseAPIManager {
	
    override func parse(response data: Dictionary<String, Any>) -> AnyObject? {
        return MessagesDataModel(with: data)
    }
	
	
}


