//
//  MessagesTableViewCell.swift
//  InterviewProject
//
//  Created by Tom on 05/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var socialType: UILabel!
    
    @IBOutlet var tweetTextView: UITextView!
    
    @IBOutlet var messageImageView: UIImageView!
    
    @IBOutlet var shareButton: UIButton!
    
    @IBOutlet var imageViewTop: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setUpView(with message: MessageDataModel?) {
        if message?.socialType == .twitter {
            if let tweet = message?.tweet {
                tweetTextView.attributedText = NSAttributedString(string: tweet)
            }
            if let screenName = message?.screenName {
                screenNameLabel.text = "@" + screenName
            }
            nameLabel.text = message?.name
            socialType.text = "via Twitter"
            image(isPresent: false)
            shareButton.isHidden = true
        } else {
            nameLabel.text = message?.message
            screenNameLabel.text = nil
            socialType.text = "via SBUT"
            if let description = message?.description {
                tweetTextView.attributedText = NSAttributedString(string: description)
            }
        }
        dateLabel.text = message?.orginalDateTime?.smartDateText()
    }
    
    private func image(isPresent present: Bool) {
        if present {
            imageViewTop.constant = 20.0
        } else {
            imageViewTop.constant = 0.0
        }
    }
    
    //MARK:- Button Actions
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
    }
}

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
