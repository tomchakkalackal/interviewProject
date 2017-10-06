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
        rootNavigationController.popViewController(animated: false)
        
        var selectedMenuController = UIViewController()
        
        switch item {
        case .home:
            selectedMenuController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        case .messages:
            selectedMenuController = MessagesViewController(nibName: "MessagesViewController", bundle: nil)
        case .imageGrid:
            selectedMenuController = GridImagesViewController(nibName: "GridImagesViewController", bundle: nil)
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
}
