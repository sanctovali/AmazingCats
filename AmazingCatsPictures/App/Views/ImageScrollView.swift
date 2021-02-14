//
//  ImageScrollView.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {

	var imageView: UIImageView!
	
	lazy var zoomingTap: UITapGestureRecognizer = {
		let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
		zoomingTap.numberOfTapsRequired = 2
		return zoomingTap
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.delegate = self
		self.showsVerticalScrollIndicator = false
		self.showsHorizontalScrollIndicator = false
		self.decelerationRate = UIScrollView.DecelerationRate.fast
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.delegate = self
		self.showsVerticalScrollIndicator = false
		self.showsHorizontalScrollIndicator = false
		self.decelerationRate = UIScrollView.DecelerationRate.fast
	}
	
	func set(image: UIImage) {
		imageView?.removeFromSuperview()
		imageView = nil
		
		imageView = UIImageView(image: image)
		self.addSubview(imageView)
		configureFor(imageSize: image.size)
	}
	
	func configureFor(imageSize: CGSize) {
		self.contentSize = imageSize
		
		limitTheZoomScale()
		self.zoomScale = self.minimumZoomScale
		
		self.imageView.addGestureRecognizer(self.zoomingTap)
		self.imageView.isUserInteractionEnabled = true

	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		centerImage()
	}
	
	func limitTheZoomScale() {
		let boundsSize = self.bounds.size
		let imageSize = imageView.bounds.size
		
		let xScale = boundsSize.width / imageSize.width
		let yScale = boundsSize.height / imageSize.height
		let minScale = min(xScale, yScale)
		
		var maxScale: CGFloat = 1.0
		if minScale < 0.1 {
			maxScale = 0.3
		}
		if minScale >= 0.1 && minScale < 0.5 {
			maxScale = 0.7
		}
		if minScale >= 0.5 {
			maxScale = max(1.0, minScale)
		}
		
		self.minimumZoomScale = minScale
		self.maximumZoomScale = maxScale
	}
	
	func centerImage() {
		let boundsSize = self.bounds.size
		var frameToCenter = imageView.frame
		
		if frameToCenter.size.width < boundsSize.width {
			frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
		} else {
			frameToCenter.origin.x = 0
		}
		
		if frameToCenter.size.height < boundsSize.height {
			frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
		} else {
			frameToCenter.origin.y = 0
		}
		
		imageView.frame = frameToCenter
	}
	
	// MARK: - Gestures
	@objc func handleZoomingTap(sender: UITapGestureRecognizer) {
		let location = sender.location(in: sender.view)
		self.zoom(point: location, animated: true)
	}
	
	func zoom(point: CGPoint, animated: Bool) {
		let currectScale = self.zoomScale
		let minScale = self.minimumZoomScale
		let maxScale = self.maximumZoomScale
		
		if (minScale == maxScale && minScale > 1) {
			return
		}
		
		let toScale = maxScale
		let finalScale = (currectScale == minScale) ? toScale : minScale
		let zoomRect = self.zoomRect(scale: finalScale, center: point)
		self.zoom(to: zoomRect, animated: animated)
	}
	
	func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
		var zoomRect = CGRect.zero
		let bounds = self.bounds
		
		zoomRect.size.width = bounds.size.width / scale
		zoomRect.size.height = bounds.size.height / scale
		
		zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
		zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
		return zoomRect
	}
	
	// MARK: - UIScrollViewDelegate
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		self.centerImage()
	}

}
