//
//  ImageLoader.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation


final class ImagesLoader {
	
	private lazy var cache = MyCache<String, CatImageData>()
		
	func setImageData(for catData: CatImageData) {
		guard !loadFromCache(catData) else { return }
		loadFromURL(for: catData)
	}
	
	func loadToCache(_ imagesData: [CatImageData], compleation: @escaping () -> Void) {
		for item in imagesData {
			loadFromURL(for: item)
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
			compleation()
		}
		
	}
	
	//MARK: - Private methods
	private func loadFromURL(for catData: CatImageData) {
		guard let url = URL(string: catData.url) else { return }
		DispatchQueue.global().async {
			catData.imageData = try? Data(contentsOf: url)
			DispatchQueue.main.async { [unowned self] in
				self.cache[catData.url] = catData
			}
		}
		
	}

	private func loadFromCache(_ catData: CatImageData) -> Bool {
		if let cached = cache[catData.url] {

				catData.imageData = cached.imageData
			
			return true
		}
		return false
	}
	
	init() {
		let folderURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
		let fileURL = folderURLs[0].appendingPathComponent("catImages" + ".cache")
		do {
		let data = try Data(contentsOf: fileURL)
			cache = try JSONDecoder().decode(MyCache.self, from: data)
		} catch {
			cache = MyCache(maxEntryCount: 75)
		}
	}
	//MARK: - Handle persistent
	func saveContent() {
		DispatchQueue.global(qos: .background).async { [unowned self] in
			do {
				try self.cache.saveToDisk(withName: "catImages")
				print("images saved into file \"catImages.cache\"")
			} catch let error {
				print("error: \(error.localizedDescription)")
			}
		}
	}
	
	func loadFromDisk(completion: ([CatImageData]) -> Void) {
		let tt = cache.loadFromDisk()
		completion(tt.compactMap{$0})
	}
	
}
