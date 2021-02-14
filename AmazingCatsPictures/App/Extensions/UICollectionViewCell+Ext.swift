//
//  UITableViewCell+Ext.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import UIKit

protocol Reusable {}

extension UICollectionViewCell: Reusable {}

extension Reusable where Self: UICollectionViewCell {
	static var reuseID: String {
		return String(describing: self)
	}
}
