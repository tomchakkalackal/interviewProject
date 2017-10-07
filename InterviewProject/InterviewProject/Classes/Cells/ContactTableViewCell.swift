//
//  ContactTableViewCell.swift
//  InterviewProject
//
//  Created by Tom on 07/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit
import Contacts

protocol CallDelegate: class {
	func call(to number: CNPhoneNumber?)
}

class ContactTableViewCell: UITableViewCell {
	
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var rightButton: UIButton!
	
	var contact: CNContact?
	
	weak var callDelegate: CallDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	func setupView(with contact: CNContact) {
		self.contact = contact
		
		if let data = contact.imageData {
			userImageView.image = UIImage(data: data)
		}
		userName.text = contact.givenName + contact.familyName
	}
	
	@IBAction func tappedRightButton(_ sender: Any) {
		callDelegate?.call(to: contact?.phoneNumbers[0].value)
	}
}
