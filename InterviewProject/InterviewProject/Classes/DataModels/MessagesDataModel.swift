//
//  MessagesDataModel.swift
//  InterviewProject
//
//  Created by Tom on 05/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import Foundation

class MessagesDataModel {
    
    var nextPageURL: String?
    var totalMessages: Double?
    var messages: [MessageDataModel]?
    
    init(with data: Dictionary<String, Any>) {
        nextPageURL = data["next_page_url"] as? String
        totalMessages = data["total"] as? Double
        messages = getMessages(from: (data["data"] as? Array))
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

class MessageDataModel {

    var messageId: Double?
    var socialType: MessageType = .twitter
    var name: String?
    var screenName: String?
    var tweet: String?
    var orginalDateTime: String?
    var message: String?
    var description: String?
    var imageURL: String?
    
    init(with data: Dictionary<String, Any>) {
        messageId = data["id"] as? Double
        if data["social_type"] as? String == "twitter" {
            socialType = .twitter
        } else {
            socialType = .sbut
        }
        name = data["name"] as? String
        screenName = data["screenName"] as? String
        tweet = data["tweet"] as? String
        orginalDateTime = data["Original_Post_DateTime"] as? String
        message = data["message"] as? String
        description = data["description"] as? String
        imageURL = data["imageurl"] as? String
    }
}
