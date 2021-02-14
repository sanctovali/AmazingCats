//
//  DetailImageViewController.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import UIKit

class DetailImageViewController: UIViewController, Storyboardable {
	
	lazy var imageScrollView: ImageScrollView = {
		let scrollView = ImageScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.delegate = scrollView
		return scrollView
	}()
	
	var catImageData: CatImageData!

    override func viewDidLoad() {
        super.viewDidLoad()
		imageScrollView = ImageScrollView(frame: view.bounds)
		view.addSubview(imageScrollView)
		setupConstraints()

    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationBar()
		setImage()
	}
	
	private func setImage() {
		if let data = catImageData.imageData, let image = UIImage(data: data) {
			imageScrollView.set(image: image)
		} else {
			imageScrollView.set(image: UIImage(named: "noimage")!)
		}
		
	}
	
	
	private func setupConstraints() {
		imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
	}
	
	private func navigationBar() {
		let text: String
		if let date = catImageData.date {
			 text = "Downloaded " + date.getFormattedDate()
		} else {
			text = ""
		}
		navigationItem.title = text
		navigationController?.navigationBar.prefersLargeTitles = false
	}
	
	
	
	
	
    


}
