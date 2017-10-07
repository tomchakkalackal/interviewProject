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

protocol EmergencyContactDelegate: class {
	func update(_ contact: CNContact?)
}

class ContactTableViewCell: UITableViewCell {
	
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var rightButton: UIButton!
	
	var contact: CNContact?
	var isEmergencyController = false
	
	weak var callDelegate: CallDelegate?
	weak var updateContactDelegate: EmergencyContactDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	func setupView(with contact: CNContact) {
		self.contact = contact
		
		if let data = contact.imageData {
			userImageView.image = UIImage(data: data)
		}
		userName.text = contact.givenName + " " + contact.familyName
	}
	
	func setCellForEmergencyContact(with contact: CNContact) {
		if EmergencyContactsManager.shared.isEmergencyContact(contact) {
			rightButton.setBackgroundImage(UIImage(named: "removeContact"), for: .normal)
		} else {
			rightButton.setBackgroundImage(UIImage(named: "addContact"), for: .normal)
		}
		setupView(with: contact)
	}
	
	@IBAction func tappedRightButton(_ sender: Any) {
		if isEmergencyController {
			updateContactDelegate?.update(contact)
		} else {
			callDelegate?.call(to: contact?.phoneNumbers[0].value)
		}
	}
}
