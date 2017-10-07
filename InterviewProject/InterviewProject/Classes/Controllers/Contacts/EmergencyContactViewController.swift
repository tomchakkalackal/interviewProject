//
//  EmergencyContactViewController.swift
//  InterviewProject
//
//  Created by Tom on 07/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit
import Contacts

class EmergencyContactViewController: BaseViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var contacts = [CNContact]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		registerNibs()
		setNavigationBar(with: "Add emergency contact")
	}
	
	private func registerNibs() {
		let contactCellNib = UINib(nibName: contactCellNIbName, bundle: nil)
		tableView.register(contactCellNib, forCellReuseIdentifier: contactCellIdentifier)
	}
}

extension EmergencyContactViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if contacts.count > 0 {
			return 1
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath) as? ContactTableViewCell
		
		cell?.updateContactDelegate = self
		cell?.isEmergencyController = true
		cell?.setCellForEmergencyContact(with: contacts[indexPath.row])
		return cell!
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60.0
	}
}

extension EmergencyContactViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = ContactsHeaderView().loadNib()
		
		header.headerLabel.text = "ALL CONTACTS"
		
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50.0
	}
}

extension EmergencyContactViewController: EmergencyContactDelegate {
	
	func update(_ contact: CNContact?) {
		if EmergencyContactsManager.shared.emergencyContactIdentifiers.count < 10 {
			guard let selectedContact = contact else {
				return
			}
			EmergencyContactsManager.shared.update(selectedContact)
			
			let index = contacts.index(of: selectedContact)
			guard let selectedIndex = index else {
				return
			}
			let indexPath = IndexPath(item: selectedIndex, section: 0)
			tableView.reloadRows(at: [indexPath], with: .none)
		} else {
			view.toast(with: "Cannot have more than 10 Emergency contacts")
		}
	}
}
