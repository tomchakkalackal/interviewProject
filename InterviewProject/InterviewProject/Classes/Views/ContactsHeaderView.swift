//
//  ContactsHeaderView.swift
//  InterviewProject
//
//  Created by Tom on 07/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

class ContactsHeaderView: UIView {

	@IBOutlet weak var headerLabel: UILabel!
	
	func loadNib() -> ContactsHeaderView {
		return Bundle.main.loadNibNamed("ContactsHeaderView", owner: nil, options: nil)![0] as! ContactsHeaderView
	}
}
