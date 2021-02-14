//
//  ViewController.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import UIKit

class ImageListViewController: UIViewController {
	
	@IBOutlet weak var imagesCollectionView: UICollectionView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	private var catApiClient = TheCatApiClient()
	let imageController = ImagesLoader()
	
	var isOnline = true {
		didSet {
			if oldValue == true {
				showError(message: NetworkError.noConnection.localizedDescription)
			}
		}
	}
	
	var catImagesData = [CatImageData]() {
		didSet {
			if oldValue.count == catImagesData.count {
				loadData(images: 5, animate: true)
			}
		}
	}
	
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupCollectionView()
		
		setupActivityIndicator()
		startUploadingData()
		imageController.loadFromDisk { [unowned self] (catimagesData) in
			self.catImagesData = catimagesData
			imagesCollectionView.reloadData()
			finisUploadingData()
		}
		
		
		
		loadData(images: 15, animate: true)

		addObservers()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationController()
	}
	
	private func setupCollectionView() {
		imagesCollectionView.delegate = self
		imagesCollectionView.dataSource = self
		
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		imagesCollectionView.refreshControl = refreshControl
	}
	
	private func setupNavigationController() {
		navigationItem.title = "Amazing Cats"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func setupActivityIndicator() {
		if #available(iOS 13, *) {
			activityIndicator.style = .medium
		} else {
			activityIndicator.style = .gray
		}
		
		activityIndicator.hidesWhenStopped = true
	}
	
	private func startUploadingData() {
		activityIndicator.startAnimating()
	}
	
	private func finisUploadingData() {
		activityIndicator.stopAnimating()
	}
	
	private func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
	}
	
	func loadData(images: Int, animate: Bool) {
		
		if animate {
			startUploadingData()
		}
		catApiClient.getRandomImagesData(dataCount: 15) { [unowned self] (result) in
			
			switch result {
			case .Success(let catImahesData):
				
				let newImages = catImahesData.compactMap{$0}
				
				if newImages.count == 0 {
					self.loadData(images: 15, animate: true)
				} else {
					self.imageController.loadToCache(newImages) {
						self.finisUploadingData()
						self.imagesCollectionView.reloadData()
					}
					self.catImagesData.append(contentsOf: newImages)

				}
			case .Failure(let error):
				self.finisUploadingData()
				isOnline = error._code == -1009 ? false : true
				if isOnline {
					showError(message: error.localizedDescription)
				}
				
			}
		}
		
	}

	@objc func refresh(with refreshControl: UIRefreshControl) {
		loadData(images: 15, animate: false)
		refreshControl.endRefreshing()
	}
	
	@objc private func saveData() {
		imageController.saveContent()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		catImagesData.count
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseID, for: indexPath) as! ImageCollectionViewCell
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let imageData = catImagesData[indexPath.row]
		
		guard let cell  = cell as? ImageCollectionViewCell else { return }
		
		if cell.catImageView.image == nil {
			
			imageController.setImageData(for: imageData)
			cell.setImage(for: imageData)
			
		}
		if indexPath.row == catImagesData.count / 2  || indexPath.row == catImagesData.count - 1 {
			loadData(images: 30, animate: false)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let vc = DetailImageViewController.instantiateFromStoryboard()
		vc.catImageData = catImagesData[indexPath.row]
		imageController.saveContent()
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension ImageListViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
				
		let size: CGSize
		let ipadSizeMultiplicator: CGFloat = 2
		switch UIScreen.main.traitCollection.userInterfaceIdiom {
		case .phone:
			size = CGSize(width: imagesCollectionView.frame.width, height: imagesCollectionView.frame.width / 1.77)
		default:
			size = CGSize(width: imagesCollectionView.frame.width / ipadSizeMultiplicator, height: imagesCollectionView.frame.width / (ipadSizeMultiplicator * 1.77))
		}
		return size
	}
}
