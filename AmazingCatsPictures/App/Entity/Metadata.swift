//
//  Metadata.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation


struct Metadata {
	var pixelHeight: Int?
	var pixelWidth: Int?
	
	init?(from dict: NSDictionary) {
		if let pixelHeight = dict["PixelHeight"] as? Int,
		   let pixelWidth = dict["PixelWidth"] as? Int {
			self.pixelHeight = pixelHeight
			self.pixelWidth = pixelWidth
		} else {
			return nil
		}
	}
}
