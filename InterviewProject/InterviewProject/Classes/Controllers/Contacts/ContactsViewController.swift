//
//  ContactsViewController.swift
//  InterviewProject
//
//  Created by Tom on 07/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit
import Contacts

let emergencyTableViewCellNibName = "EmergencyContactTableViewCell"
let emergencyCellIdentifier = "EmergencyCell"
let contactCellNIbName = "ContactTableViewCell"
let contactCellIdentifier = "ContactCell"

let navigationBarTintColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)

class ContactsViewController: BaseViewController {
	
	@IBOutlet weak var tableView: UITableView!

	var contacts = [CNContact]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		addSideMenuNavigationButton()
		setBarTint(with: navigationBarTintColor)
		setNavigationBar(with: "All Contacts")
		
		registerNibs()
		
		getContacts()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		reload()
	}
	
	//MARK:- CollectionView Helpers
	
	private func registerNibs() {
		let emergencyCellNib = UINib(nibName: emergencyTableViewCellNibName, bundle: nil)
		tableView.register(emergencyCellNib, forCellReuseIdentifier: emergencyCellIdentifier)
		
		let contactCellNib = UINib(nibName: contactCellNIbName, bundle: nil)
		tableView.register(contactCellNib, forCellReuseIdentifier: contactCellIdentifier)
	}
	
	private func reload() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	//MARK:- Contacts Fetch Helpers
	
	private func getContacts() {
		let contactStore = CNContactStore()

		let keysToFetch = [
			CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
			CNContactImageDataKey,
			CNContactPhoneNumbersKey
			] as [Any]
		
		let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
		
		do {
			try contactStore.enumerateContacts(with: request) {
				(contact, stop) in
				self.contacts.append(contact)
			}
		}
		catch {
			print("unable to fetch contacts")
			return
		}
		reload()
	}
}

//MARK:- UITableViewDataSource

extension ContactsViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if contacts.count > 0 {
			return 2
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return contacts.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: emergencyCellIdentifier, for: indexPath) as? EmergencyContactTableViewCell
			
			cell?.delegate = self
			cell?.emergencyContacts = EmergencyContactsManager.shared.fetch(from: contacts)
			cell?.setupCollectionView()
			return cell!
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath) as? ContactTableViewCell
			
			cell?.callDelegate = self
			cell?.setupView(with: contacts[indexPath.row])
			return cell!
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 115.0
		}
		return 60.0
	}
}

//MARK:- UITableViewDelegate

extension ContactsViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = ContactsHeaderView().loadNib()
		if section == 0 {
			header.headerLabel.text = "EMERGENCY CONTACT"
		} else {
			header.headerLabel.text = "ALL CONTACTS"
		}
		
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50.0
	}
}

//MARK:- CallDelegate

extension ContactsViewController: CallDelegate {
	
	//Couldn't test this function as I was debugging on a simulator.
	func call(to number: CNPhoneNumber?) {
		
		guard let value = number, let phoneNumber = URL(string: "tel://" + value.stringValue) else {
			print("Couldn't make a call")
			return
		}
		UIApplication.shared.open(phoneNumber)
	}
}

//MARK:- AddEmergencyContact

extension ContactsViewController: AddEmergencyContact {
	func add() {
		let emergencyContactViewController = EmergencyContactViewController(nibName: "EmergencyContactViewController", bundle: nil)
		
		emergencyContactViewController.contacts = contacts
		navigationController?.pushViewController(emergencyContactViewController, animated: false)
	}
}
