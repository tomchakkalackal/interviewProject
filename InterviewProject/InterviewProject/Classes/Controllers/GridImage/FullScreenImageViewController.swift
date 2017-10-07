//
//  FullScreenImageViewController.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import UIKit

class FullScreenImageViewController: BaseViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	
	var images: [GridImagesDataModel]?
	var selectedIndexPath: IndexPath?
	var currentCellIndex: CGFloat = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()

		registerNibs()
		currentCellIndex = CGFloat(selectedIndexPath!.item)
		//self.automaticallyAdjustsScrollViewInsets = false
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		collectionView.collectionViewLayout = collectionViewFlowLayout()
		collectionViewInitialSetUp()
	}
	
	//MARK:- CollectionView Helpers
	
	private func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
		let flowLayout = UICollectionViewFlowLayout()
		
		flowLayout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		flowLayout.minimumInteritemSpacing =  0
		flowLayout.minimumLineSpacing = 0
		flowLayout.scrollDirection = .horizontal
		
		return flowLayout
	}
	
	private func collectionViewInitialSetUp() {
		collectionView.scrollToItem(at: selectedIndexPath!, at: .centeredHorizontally, animated: false)
	}
	
	private func registerNibs() {
		let gridCellNib = UINib(nibName: gridCellNibName, bundle: nil)
		collectionView.register(gridCellNib, forCellWithReuseIdentifier: gridCellIdentifier)
	}
}

extension FullScreenImageViewController: UICollectionViewDataSource {
	
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

//extension FullScreenImageViewController: UICollectionViewDelegateFlowLayout {
//	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 100)
//	}
//	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//		return CGFloat.leastNonzeroMagnitude
//	}
//	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//		return CGFloat.leastNonzeroMagnitude
//	}
//}

extension FullScreenImageViewController: UIScrollViewDelegate {
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
	{
		
		let cellWidth = collectionView.frame.width
		var offset = targetContentOffset.pointee
		let index = (offset.x + scrollView.contentInset.left) / cellWidth
		let roundedIndex = round(index)
		if currentCellIndex != roundedIndex {
			if roundedIndex > currentCellIndex {
				currentCellIndex += 1
			} else {
				currentCellIndex -= 1
			}
		}
		
		offset = CGPoint(x: currentCellIndex * cellWidth, y: 0)
		targetContentOffset.pointee = offset
	}
}
