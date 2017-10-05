//
//  BaseAPIManager.swift
//  InterviewProject
//
//  Created by Tom on 05/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import Foundation

class BaseAPIManager {
	
	var urlString: String
	
	init(with url: String) {
		
		urlString = url
	}
	
	class func callAPI() {
		let url = URL(string: "https://private-71386-getmessagestest.apiary-mock.com/get_messages")!
		
		let session = URLSession.shared
		
		let request = URLRequest(url: url)
		
		let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
			
			guard error == nil else {
				return
			}
			
			guard let data = data else {
				return
			}
			
			do {
				if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
					print(json)
				}
			} catch let error {
				print(error.localizedDescription)
			}
		})
		
		task.resume()
	}
	
	func parse(response data: AnyObject) {
		
	}
	
}
