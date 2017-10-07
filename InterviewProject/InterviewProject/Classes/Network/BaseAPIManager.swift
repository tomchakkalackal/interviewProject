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
    
    func fetchData(success: @escaping (_ successResponse: AnyObject?) -> (), failure: (_ failureMessage: String) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Failed to initiate request as the url provided is invalid")
            return
        }
        
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
                    success(self.parse(response: json))
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
	
	//MARK:- Abstract method to parse the JSON Response - Should be overriden in the child
	
    func parse(response data: Dictionary<String, Any>) -> AnyObject? {
        print("parse(response: Dictionary)' method should be overriden")
        return nil
    }
    
}
