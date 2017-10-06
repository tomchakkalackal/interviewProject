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
    
    var url = "https://private-71386-getmessagestest.apiary-mock.com/get_messages"
    var messageModel: MessagesDataModel?
    
    var dataSource: [MessageDataModel]?
    var allMessages: [MessageDataModel]?
    var sbutMessages: [MessageDataModel]?
    var twitterMessages: [MessageDataModel]?
    
    var noDataView: UIView?
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        addSideMenuNavigationButton()
        registerNibs()
        fetchData(with: url)
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
            guard allMessages != nil else {
                allMessages = messageModel?.messages
                dataSource = allMessages
                break
            }
            dataSource = allMessages
        case 1:
            guard sbutMessages != nil else {
                sbutMessages = filter(messagesFor: .sbut)
                dataSource = sbutMessages
                break
            }
            dataSource = sbutMessages
        case 2:
            guard twitterMessages != nil else {
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
    
    private func fetchData(with url: String) {
        let apiManager = MessagesAPIManager(with: url)
        apiManager.fetchData(success: { (successModel) in
            guard let model = successModel as? MessagesDataModel else {
                return
            }
            self.messageModel = model
            self.updateDataSourceAndReload()
        }, failure: { (errorString) in
            print(errorString)
        })
    }
    
    //MARK:- Button Actions
    
    @IBAction func tabIndexChanged(_ sender: Any) {
        updateDataSourceAndReload()
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
        
        cell?.layer.cornerRadius = 5.0
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
