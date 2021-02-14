//
//  UIViewController+Ext.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import UIKit

//MARK: - Alerts
enum AlertAction {
	case ok
	
	func getAction() -> UIAlertAction {
		switch self {
		case .ok:
			return UIAlertAction(title: "Ок", style: .default, handler: nil)
		}
	}
}

extension UIViewController {
	func showAlert(with title: String, message: String, actions: [UIAlertAction], ofType type: UIAlertController.Style) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach { ac.addAction($0) }
		DispatchQueue.main.async { [weak self] in
			self?.present(ac, animated: true, completion: nil)
		}
		
	}
	//MARK: - Default error alert
	func showError(with title: String = "Error", message: String, actions: [UIAlertAction] = [AlertAction.ok.getAction()], ofType type: UIAlertController.Style = .alert) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach{ac.addAction($0)}
		DispatchQueue.main.async { [weak self] in
			self?.present(ac, animated: true, completion: nil)
		}
	}
}

//MARK: - Storyboardable
protocol Storyboardable: class {}

extension Storyboardable {
	static func instantiateFromStoryboard() -> Self {
		return instantiateFromStoryboardHelper()
	}
	
	private static func instantiateFromStoryboardHelper<T>() -> T {
		let identifier = String(describing: self)
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: identifier) as! T
	}
}
