//
//  Date+Ext.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

extension Date {
	
	func getFormattedDate(format: String = "MMM d") -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.setLocalizedDateFormatFromTemplate(format)
		dateFormatter.locale = .autoupdatingCurrent
		return dateFormatter.string(from: self)
	}
}
