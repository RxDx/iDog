//
//  BreedImagesController.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import UIKit

class BreedImagesController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: BreedImagesViewModel?
    
    // MARK: - State
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.getBreedImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func clickOnFavoriteButton(_ sender: Any) {
    }
    
    // MARK: - Storyboard
    static func storyboardInstance(breed: Breed) -> BreedImagesController? {
        let storyboard = UIStoryboard(name: "BreedImages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BreedImages") as? BreedImagesController
        
        controller?.viewModel = BreedImagesViewModel(delegate: controller, breed: breed)

        return controller
    }
    
}

// ViewModelDelegate
extension BreedImagesController: BreedImagesViewModelDelegate {
    func updateUI() {
        collectionView.reloadData()
    }
}

// CollectionView
extension BreedImagesController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.breedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedImage", for: indexPath) as? BreedImageCell else {
            return UICollectionViewCell()
        }
        
        cell.breedImage = viewModel?.breedImages?[indexPath.item]
        
        return cell
    }
}
