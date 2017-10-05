//
//  MessagesViewController.swift
//  InterviewProject
//
//  Created by Tom on 05/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

let messageCellNibName = "MessagesTableViewCell"
let messageCellIdentifier = "MessageCellIdentifier"

class MessagesViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 140
		registerNibs()
		BaseAPIManager.callAPI()
	}
	
	//MARK:- Tableview Helpers
	
	private func registerNibs() {
		let messageCellNib = UINib(nibName: messageCellNibName, bundle: nil)
		tableView.register(messageCellNib, forCellReuseIdentifier: messageCellIdentifier)
	}
}

extension MessagesViewController: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath)
		
		cell.layer.cornerRadius = 5.0
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}
}
