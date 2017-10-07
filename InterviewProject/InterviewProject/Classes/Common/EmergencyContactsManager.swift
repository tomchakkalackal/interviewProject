//
//  ContactsManager.swift
//  InterviewProject
//
//  Created by Tom on 07/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import Foundation
import Contacts

class EmergencyContactsManager {
	
	static let shared = EmergencyContactsManager()
	
	private init() { }
	
	var emergencyContactIdentifiers = [String]()
	
	//Helper Methods
	
	func fetch(from contacts: [CNContact]) -> [CNContact] {
		var emergencyContacts = [CNContact]()
		
		for identifier in emergencyContactIdentifiers {
			let filteredContacts = contacts.filter({$0.identifier == identifier})
			if filteredContacts.count > 0 {
				emergencyContacts.append(filteredContacts.first!)
			}
		}
		
		return emergencyContacts
	}
	
	func update(_ contact: CNContact) {
		if isEmergencyContact(contact) {
			remove(contact)
		} else {
			add(contact)
		}
	}
	
	private func add(_ contact: CNContact) {
		emergencyContactIdentifiers.append(contact.identifier)
	}
	
	private func remove(_ contact: CNContact) {
		let contactToRemove = emergencyContactIdentifiers.filter({$0 == contact.identifier})
		if !contactToRemove.isEmpty {
			emergencyContactIdentifiers.remove(at: emergencyContactIdentifiers.index(of: contactToRemove.first!)!)
		}
	}
	
	func isEmergencyContact(_ contact: CNContact) -> Bool {
		if emergencyContactIdentifiers.filter({$0 == contact.identifier}).isEmpty {
			return false
		}
		return true
	}
}
