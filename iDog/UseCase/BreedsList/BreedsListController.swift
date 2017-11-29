//
//  BreedsListController.swift
//  iDog
//
//  Created by Rodrigo Dumont on 28/11/17.
//  Copyright © 2017 Rodrigo Dumont. All rights reserved.
//

import UIKit

class BreedsListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: BreedsListViewModel?
    
    // MARK: - State
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        
        viewModel = BreedsListViewModel(delegate: self)
        viewModel?.getBreeds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - RefreshControl
    @objc func refreshControlValueChanged() {
        tableView.refreshControl?.endRefreshing()
        viewModel?.getBreeds()
    }
    
    // MARK: - Storyboard
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "BreedsList", bundle: nil)
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }

}

extension BreedsListController: BreedListViewModelDelegate {
    
    func updateUI() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableView
extension BreedsListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath) as? BreedCell,
            let breed = viewModel?.breedFor(section: indexPath.section, row: indexPath.row) else {
                return UITableViewCell()
        }
        
        cell.breed = breed
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Breed \(Array(viewModel!.breedsHash.keys).sorted()[section])"
//    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Array(viewModel!.breedsHash.keys).sorted().map{"\($0)"}
    }
}

extension BreedsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let breed = viewModel?.breedFor(section: indexPath.section, row: indexPath.row),
            let controller = BreedImagesController.storyboardInstance(breed: breed) {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
