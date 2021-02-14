//
//  CatApiClient.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

final class TheCatApiClient: NetworkService {
	
	init() {
		super.init()
	}
	
	private var loadingInProgress = false
	
	//MARK: - getRandomImagesData -

	func getRandomImagesData(dataCount: Int, comletion: @escaping (APIResult<[CatImageData?]>) -> Void) {
		
		guard !loadingInProgress else { return }
		
		guard URL.isConnectionAvailable else {
			comletion(.Failure(NetworkError.noConnection))
			return
		}
		loadingInProgress = true
		let request = CatApiRouter.random(dataCount).request
		fetch(request: request, parse: { [unowned self] (json) -> [CatImageData?] in
			
			self.parse(from: json)
		}, completionHandler: comletion)
		loadingInProgress = false
	}

}
