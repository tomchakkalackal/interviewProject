//
//  GridImagesViewController.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

let gridCellNibName = "GridimageCollectionViewCell"
let fullScreenVCNibName = "FullScreenImageViewController"
let gridCellIdentifier = "GridimageCell"

class GridImagesViewController: BaseViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	
	let url = "http://private-e1b8f4-getimages.apiary-mock.com/getImages"
	var images: [GridImagesDataModel]?
	
	var gridWidth: CGFloat = 100.0
	var interimSpace: CGFloat = 10.0
	var offset: CGFloat = 10.0
	
    override func viewDidLoad() {
        super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

		addSideMenuNavigationButton()
		setupCollectionView()
		addGesture()
		registerNibs()
		fetchData()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		gridWidth = (view.frame.width - (2 * interimSpace) - (2 * offset) - 5) / 3
	}
	
	//MARK:- Collectionview Helpers
	
	private func setupCollectionView() {
		collectionView.contentInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
	}
	
	private func registerNibs() {
		let gridCellNib = UINib(nibName: gridCellNibName, bundle: nil)
		collectionView.register(gridCellNib, forCellWithReuseIdentifier: gridCellIdentifier)
	}
	
	//MARK:- API Helpers
	
	private func fetchData() {
		let apiManager = GridImagesAPIManager(with: url)
		apiManager.fetchData(success: { (successModel) in
			guard let model = successModel as? [GridImagesDataModel] else {
				return
			}
			self.images = model
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}, failure: { (errorString) in
			print(errorString)
		})
	}
	
	//MARK:- Orientation Change Handler
	
	@objc private func rotated() {
		gridWidth = (view.frame.width - (2 * interimSpace) - (2 * offset) - 5) / 3
		collectionView.collectionViewLayout.invalidateLayout()
	}
	
	//MARK:- Gesture Recognizer Helpers
	
	private func addGesture() {
		let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
		collectionView.addGestureRecognizer(longTapGesture)
	}
	
	@objc private func longPressed(longPressGesture: UILongPressGestureRecognizer) {
		let pressPoint = longPressGesture.location(in: collectionView)
		
		if let indexPath = collectionView.indexPathForItem(at: pressPoint) {
			UIPasteboard.general.string = images?[indexPath.item].imageURL
			view.toast(with: "Successfully copied to clipboard")
		}
	}
	
	//MARK:- deinit
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
	}
}

extension GridImagesViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		guard let images = images, images.count > 0 else {
			return 0
		}
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return images!.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellIdentifier, for: indexPath) as? GridimageCollectionViewCell
		
		cell?.setupCell(with: images?[indexPath.item], at: indexPath)
		return cell!
	}
}

extension GridImagesViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let fullScreenViewController = FullScreenImageViewController(nibName: fullScreenVCNibName, bundle: nil)
		fullScreenViewController.images = images
		fullScreenViewController.selectedIndexPath = indexPath
		
		navigationController?.pushViewController(fullScreenViewController, animated: false)
	}
}

extension GridImagesViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: gridWidth, height: gridWidth)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return interimSpace
	}
}
