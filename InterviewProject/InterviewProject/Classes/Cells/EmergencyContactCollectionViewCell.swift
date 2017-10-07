//
//  EmergencyContactCollectionViewCell.swift
//  InterviewProject
//
//  Created by Tom on 07/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit
import Contacts

class EmergencyContactCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var contactImage: UIImageView!
	@IBOutlet weak var contactLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func setupCell(with contact: CNContact) {
		
		contactImage.image = nil
		if let data = contact.imageData {
			contactImage.image = UIImage(data: data)
		}
		contactLabel.text = contact.givenName + " " + contact.familyName
	}
}
