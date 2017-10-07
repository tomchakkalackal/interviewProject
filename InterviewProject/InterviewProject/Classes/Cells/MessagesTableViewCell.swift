//
//  MessagesTableViewCell.swift
//  InterviewProject
//
//  Created by Tom on 05/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

protocol ShareMessageDelegate: class {
	func share(_ message: String?, description: String?)
}

protocol ImageViewTapDelegate {
	func tapped(at indexPath: IndexPath)
}

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var socialType: UILabel!
    
    @IBOutlet var tweetTextView: UITextView!
    
    @IBOutlet var messageImageView: UIImageView!
    
    @IBOutlet var shareButton: UIButton!
    
    @IBOutlet var imageViewTop: NSLayoutConstraint!
	@IBOutlet weak var imageViewHeight: NSLayoutConstraint!
	
	weak var shareDelegate: ShareMessageDelegate?
	var message: MessageDataModel?
	
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setUpView(with message: MessageDataModel?) {
		setTextViewProperties()
		messageImageView?.image = nil
		self.message = message
		
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
			if let description = message?.description {
				tweetTextView.attributedText = NSAttributedString(string: description)
			}
			if let url = message?.imageURL {
				messageImageView?.imageFromURL(urlString: url)
			}
            nameLabel.text = message?.message
            screenNameLabel.text = nil
            socialType.text = "via SBUT"
			image(isPresent: true)
			shareButton.isHidden = false
        }
        dateLabel.text = message?.orginalDateTime?.smartDateText()
    }
    
    private func image(isPresent present: Bool) {
        if present {
			imageViewHeight.constant = 300.0
            imageViewTop.constant = 20.0
        } else {
			imageViewHeight.constant = 0.0
            imageViewTop.constant = 0.0
        }
    }
	
	private func setTextViewProperties() {
		
		let linkTextAttributes : [String : Any] = [
			NSForegroundColorAttributeName: UIColor.blue,
			NSUnderlineColorAttributeName: UIColor.blue,
			NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
		]
		
		tweetTextView.linkTextAttributes = linkTextAttributes
	}
	
    //MARK:- Button Actions
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        shareDelegate?.share(message?.message, description: message?.description)
    }
}


