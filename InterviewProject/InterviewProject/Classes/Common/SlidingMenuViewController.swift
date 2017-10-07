//
//  SlidingMenuViewController.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

enum SlidingMenuItems {
    case home
    case messages
    case imageGrid
	case contacts
}

class SlidingMenuViewController: UIViewController {
    
    var rootNavigationController: UINavigationController!
    
    var selectedMenu: SlidingMenuItems = .home
	
	var isRootNavigationSetup = false

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if !isRootNavigationSetup {
			initializeRootNavigation()
		}
	}

    private func initializeRootNavigation() {
        let home = HomeViewController(nibName: "HomeViewController", bundle: nil)
        rootNavigationController = UINavigationController(rootViewController: home)
        rootNavigationController?.view.frame = UIScreen.main.bounds
        
        self.view.addSubview(rootNavigationController.view)
        
        rootNavigationController.navigationBar.backgroundColor = UIColor.gray
		isRootNavigationSetup = true
    }
    
    //MARK:- Slider toggling Helpers
    
    func show(menu item: SlidingMenuItems) {
        if selectedMenu == item {
            dismissSlideMenu()
            return
        }
		selectedMenu = item
        rootNavigationController.popToRootViewController(animated: false)
        
        var selectedMenuController = UIViewController()
        
        switch item {
        case .home:
			dismissSlideMenu()
            return
        case .messages:
            selectedMenuController = MessagesViewController(nibName: "MessagesViewController", bundle: nil)
        case .imageGrid:
            selectedMenuController = GridImagesViewController(nibName: "GridImagesViewController", bundle: nil)
		case .contacts:
			selectedMenuController = ContactsViewController(nibName: "ContactsViewController", bundle: nil)
        }
        
        rootNavigationController.pushViewController(selectedMenuController, animated: false)
        dismissSlideMenu()
    }
    
    func dismissSlideMenu() {
        UIView.animate(withDuration: 0.5) { () -> Void in
            if let navController = self.rootNavigationController {
                var frame = navController.view.frame
                frame.origin.x = 0
                navController.view.frame = frame
            }
        }
    }
    
    //MARK:- Button Actions
    
    @IBAction func homeTapped(_ sender: Any) {
        show(menu: .home)
    }
    
    @IBAction func messagesTapped(_ sender: Any) {
        show(menu: .messages)
    }
    
    @IBAction func imageGridTapped(_ sender: Any) {
        show(menu: .imageGrid)
    }
	
	@IBAction func contactsTapped(_ sender: Any) {
		show(menu: .contacts)
	}
}
