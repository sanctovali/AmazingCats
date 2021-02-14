//
//  ImageTableViewCell.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import UIKit


class ImageCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var catImageView: UIImageView!
	@IBOutlet weak var metadataLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		configureView()
	}
	
	private func configureView() {
		catImageView.contentMode = .scaleAspectFill
	}
	
	override func prepareForReuse() {
		catImageView.image = nil
	}
	
	
	func setImage(for catImage: CatImageData) {
		guard let data = catImage.imageData else { return }
		catImageView.image = UIImage(data: data)
		
		let size: String
		if let width = catImage.metadata?.pixelWidth, let height = catImage.metadata?.pixelHeight {
			size = "\(width) x \(height)"
		} else {
			size = "not defined"
		}
		layoutSubviews()
		catImageView.layer.cornerRadius = catImageView.frame.height / 15
		metadataLabel.text = "Image size in Pixels = \(size)"
		
	}
	
}
