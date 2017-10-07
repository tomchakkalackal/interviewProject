//
//  MessagesViewController.swift
//  InterviewProject
//
//  Created by Tom on 05/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

enum MessageType {
	case sbut
	case twitter
	case all
}

let messageCellNibName = "MessagesTableViewCell"
let messageCellIdentifier = "MessageCellIdentifier"

class MessagesViewController: BaseViewController {
	
	let barTintColor = UIColor(red: 227/255, green: 138/255, blue: 36/225, alpha: 1)
	var apiURL = "https://private-71386-getmessagestest.apiary-mock.com/get_messages"
	var isPaginating = false
	
	var messageModel: MessagesDataModel?
	var dataSource: [MessageDataModel]?
	var allMessages: [MessageDataModel]?
	var sbutMessages: [MessageDataModel]?
	var twitterMessages: [MessageDataModel]?
	
	var noDataView: UIView?
	var imagePopOutView: ImagePopOutView?
	
	@IBOutlet var segmentedControl: UISegmentedControl!
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 140
		self.automaticallyAdjustsScrollViewInsets = false
		
		setBarTint(with: barTintColor)
		setNavigationBar(with: "Messaging")
		addSideMenuNavigationButton()
		
		registerNibs()
		
		fetchData()
	}
	
	//MARK:- Tableview Helpers
	
	private func registerNibs() {
		let messageCellNib = UINib(nibName: messageCellNibName, bundle: nil)
		tableView.register(messageCellNib, forCellReuseIdentifier: messageCellIdentifier)
	}
	
	private func filter(messagesFor type: MessageType) -> [MessageDataModel]? {
		guard let messages = messageModel?.messages else {
			return nil
		}
		return messages.filter({$0.socialType == type})
	}
	
	private func updateDataSourceAndReload() {
		switch segmentedControl.selectedSegmentIndex {
		case 0:
			guard allMessages != nil, !isPaginating else {
				allMessages = messageModel?.messages
				dataSource = allMessages
				break
			}
			dataSource = allMessages
		case 1:
			guard sbutMessages != nil, !isPaginating else {
				sbutMessages = filter(messagesFor: .sbut)
				dataSource = sbutMessages
				break
			}
			dataSource = sbutMessages
		case 2:
			guard twitterMessages != nil, !isPaginating else {
				twitterMessages = filter(messagesFor: .twitter)
				dataSource = twitterMessages
				break
			}
			dataSource = twitterMessages
		default:
			return
		}
		reload()
	}
	
	private func reload() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	fileprivate func showNoDataView() {
		let noDataLabel = UILabel()
		noDataLabel.text = "No messages to be shown"
		noDataLabel.textColor = UIColor.darkGray
		noDataLabel.textAlignment = .center
		self.tableView.backgroundView = noDataLabel
		
	}
	
	//MARK:- API Helpers
	
	fileprivate func fetchData() {
		let apiManager = MessagesAPIManager(with: apiURL)
		apiManager.fetchData(success: { (successModel) in
			guard let model = successModel as? MessagesDataModel, let messages = model.messages else {
				self.isPaginating = false
				return
			}
			if self.isPaginating {
				self.messageModel?.nextPageURL = model.nextPageURL
				self.messageModel!.messages! += messages //Forcefull unwrapping done as it will certainly have data.
			} else {
				self.messageModel = model
			}
			self.updateDataSourceAndReload()
			self.isPaginating = false
		}, failure: { (errorString) in
			self.isPaginating = false
			print(errorString)
		})
	}
	
	//MARK:- Pagination
	
	fileprivate func paginate() {
		if !isPaginating && segmentedControl.selectedSegmentIndex == 0 {
			isPaginating = true
			guard let nextURL = messageModel?.nextPageURL else {
				return
			}
			apiURL = nextURL
			print(apiURL)
			fetchData()
		}
	}
	
	//MARK:- Button Actions
	
	@IBAction func tabIndexChanged(_ sender: Any) {
		updateDataSourceAndReload()
	}
	
	//MARK:- Gesture Handlers
	
	func imageTapped(gestureRecognizier: UITapGestureRecognizer) {
		let tag = gestureRecognizier.view?.tag
		guard let section = tag, let url = dataSource?[section].imageURL else {
			return
		}
		
		imagePopOutView = ImagePopOutView().loadNib()
		imagePopOutView?.zoomImageView?.imageFromURL(urlString: url)
		imagePopOutView?.addTapGesture()
		imagePopOutView?.setupScrollView()
		view.addSubview(imagePopOutView!)
		imagePopOutView?.frame.size = view.frame.size
	}
}

//MARK:- UITableViewDataSource

extension MessagesViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		guard let messages = dataSource, messages.count > 0 else {
			showNoDataView()
			return 0
		}
		tableView.backgroundView = nil
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath) as? MessagesTableViewCell
		
		cell?.shareDelegate = self
		cell?.layer.cornerRadius = 8.0
		cell?.messageImageView.tag = indexPath.section
		
		let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizier:)))
		cell?.messageImageView.addGestureRecognizer(imageTap)
		
		cell?.setUpView(with: dataSource?[indexPath.section])
		return cell!
	}
}

//MARK:- UITableViewDelegate

extension MessagesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footerView = UIView()
		footerView.backgroundColor = UIColor.clear
		
		return footerView
	}
}

//MARK:- UIScrollViewDelegate

extension MessagesViewController: UIScrollViewDelegate {
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
			paginate()
		}
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
			paginate()
		}
	}
}

//MARK:- ShareMessageDelegate

extension MessagesViewController: ShareMessageDelegate {

	func share(_ message: String?, description: String?) {
		
		var objectsToShare = [String]()
		if let message = message {
			objectsToShare.append(message)
		}
		if let description = description {
			objectsToShare.append(description)
		}
		
		let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
		self.present(activityVC, animated: true, completion: nil)
	}
}
