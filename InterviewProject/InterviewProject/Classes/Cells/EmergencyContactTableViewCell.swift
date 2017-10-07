//
//  EmergencyContactTableViewCell.swift
//  InterviewProject
//
//  Created by Tom on 07/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit
import Contacts

let emergencyContactCellNibName = "EmergencyContactCollectionViewCell"
let emergencyContactIdentifier = "emergencyContactCellIdentifier"

protocol AddEmergencyContact: class {
	func add()
}

class EmergencyContactTableViewCell: UITableViewCell {
	
	weak var delegate: AddEmergencyContact?
	
	var emergencyContacts = [CNContact]()

	@IBOutlet weak var collectionView: UICollectionView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		registerNibs()
		collectionView.reloadData()
    }
	
	func setupCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.reloadData()
	}
	
	private func registerNibs() {
		let gridCellNib = UINib(nibName: emergencyContactCellNibName, bundle: nil)
		collectionView.register(gridCellNib, forCellWithReuseIdentifier: emergencyContactIdentifier)
	}
}

extension EmergencyContactTableViewCell: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if emergencyContacts.count > 0 {
			return emergencyContacts.count + 1
		}
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emergencyContactIdentifier, for: indexPath) as? EmergencyContactCollectionViewCell
		
		if indexPath.item == emergencyContacts.count {
			cell?.contactImage.image = UIImage(named: "addContact")
			cell?.contactLabel.text = nil
		} else {
			cell?.setupCell(with: emergencyContacts[indexPath.item])
		}
		return cell!
	}
}

extension EmergencyContactTableViewCell: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.item == emergencyContacts.count {
			delegate?.add()
		}
	}
}

extension EmergencyContactTableViewCell: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 60.0, height: 100.0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 20.0
	}
}

