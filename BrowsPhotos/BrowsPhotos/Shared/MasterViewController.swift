//
//  MasterViewController.swift
//  BrowsPhotos
//
//  Created by chaloemphong on 23/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class MasterViewController: UITableViewController {

    // MARK: Types for managing sections, cell, and segue identifiers
    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = 3
    }
    
    enum CellIdentifier: String {
        case allPhotos, collection
    }
    
    enum SegueIdentifier: String {
        case showAllPhotos
        case showCollection
    }
    
    // Mark: Propoties
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    let sectionLocalizedTitle = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    // MARK: UIViewController / Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.addAlbum))
        self.navigationItem.rightBarButtonItem = addButton
        
        let allPhotosOptions = PHFetchOptions()
//        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        PHPhotoLibrary.shared().register(self)
        
    }
    
    /// - Tag: UnregisterChangeObserver
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        
        super.viewWillAppear(animated)
    }
    
    
    /// - Tag: CreateAlbum
    @objc
    func addAlbum(_ sender: AnyObject) {
        let alertController = UIAlertController(title: NSLocalizedString("New Album", comment: ""), message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Album name", comment: "")
        }
        
        alertController.addAction(UIAlertAction.init(title: NSLocalizedString("Create ", comment: ""), style: .default, handler: { (action) in
            let textField = alertController.textFields?.first
            if let title = textField?.text , !title.isEmpty {
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                }, completionHandler: { (success, error) in
                    if !success { print("Error Creating Album \(String(describing: error)).")}
                })
            }
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = (segue.destination as? UINavigationController)?.topViewController as? AssetGridViewController else { fatalError("Unexpected view controller for segue.") }
        guard let cell = sender as? UITableViewCell else { fatalError("Unexpected sender for segue.") }
        
        destination.title = cell.textLabel?.text
        
        switch SegueIdentifier(rawValue: segue.identifier!)! {
        case .showAllPhotos:
            destination.fetchResult = allPhotos
        case .showCollection:
            // fetch asset colelction for select row
            let indexPath = tableView.indexPath(for: cell)!
            let collection: PHCollection
            switch Section(rawValue: indexPath.section)! {
            case .smartAlbums:
                collection = smartAlbums.object(at: indexPath.row)
            case .userCollections:
                collection = userCollections.object(at: indexPath.row)
            default:
                return
            }
            
            guard let assetCollection = collection as? PHAssetCollection else {fatalError("Expected an asset collection.")}
            destination.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            destination.assetCollection = assetCollection
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
//        default:return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.allPhotos.rawValue, for: indexPath)
            cell.textLabel?.text = NSLocalizedString("All Photos", comment: "")
            return cell
        case .smartAlbums:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.collection.rawValue, for: indexPath)
            let collection = smartAlbums.object(at: indexPath.row)
            cell.textLabel?.text = collection.localizedTitle
            return cell
        case .userCollections:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.collection.rawValue, for: indexPath)
            let collection = userCollections.object(at: indexPath.row)
            cell.textLabel?.text = collection.localizedTitle
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLocalizedTitle[section]
    }

}


extension MasterViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
                
            }
            
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
            }
            
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.userCollections.rawValue), with: .automatic)
            }
        }
    }
}
