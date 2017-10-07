//
//  PhotosManager.swift
//  InterviewProject
//
//  Created by Tom on 06/10/17.
//  Copyright © 2017 TomChakkalackal. All rights reserved.
//

import Foundation

class PhotosManager {
	
	static let shared = PhotosManager()
	
	private init() { }
	
	var cache = [ImageCache]()
	
}
