//
//  CatImageData.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import UIKit

class CatImageData: Codable {
	
	var url: String
	var imageData: Data?
	var date: Date?

	var metadata: Metadata? {
		if let data = imageData, let imageSource = CGImageSourceCreateWithData(data as CFData, nil) {
			  if let dictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) {
				return Metadata(from: dictionary)
			}
		}
		return nil
	}
	
	private enum CodingKeys: String, CodingKey {
		case url, imageData, date
	}
	
	required init(from decoder: Decoder) throws {

		guard let container = try? decoder.container(keyedBy: CodingKeys.self)  else { let error = NetworkError.parseProblem; throw error }
		do {
			let url = try container.decode(String.self, forKey: .url)
			self.url = url
			self.imageData = try? container.decode(Data.self, forKey: .imageData)
			self.date = try? container.decode(Date.self, forKey: .date)
			date = date ?? Date()
		
		} catch let error {
			throw error
		}

	}
	
}

//MARK: - Hashable
extension CatImageData: Hashable {
	static func == (lhs: CatImageData, rhs: CatImageData) -> Bool {
		return lhs.url == rhs.url
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(url)
	}
}
