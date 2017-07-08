//
//  PugCollectionViewController.swift
//  DisneyCodingChallenge
//
//  Created by Wellington Moreno on 7/7/17.
//  Copyright © 2017 Disney, Inc. All rights reserved.
//

import Foundation
import UIKit

class PugCollectionViewController: UICollectionViewController {
    
    fileprivate var images = [URL]()
    
    fileprivate let async: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        return queue
    }()
    
    fileprivate let main = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadPugs()
    }
}

//MARK: Loading Data
fileprivate extension PugCollectionViewController {
    
    func loadPugs() {
        
        showIndicator()
        
        PugMeAPI.loadPugs() { [weak self] pugs in
            
            guard let `self` = self else { return }
        
            
            self.main.addOperation {
                
                defer { self.hideIndicator() }
                
                let newIndexes = self.createNewIndexesToInsertBasedOn(newPugs: pugs)
                
                self.images += pugs
                
                self.collectionView?.insertItems(at: newIndexes)
                
            }
        }
    }
    
    func showIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func createNewIndexesToInsertBasedOn(newPugs: [URL]) -> [IndexPath] {
        
        var currentIndex = self.images.count
        
        let newIndexes: [IndexPath] = newPugs.map{ _ in
            
            let path = IndexPath(row: currentIndex, section: 0)
            currentIndex += 1
            return path
        }
        
        return newIndexes
    }
}

//MARK: Collection View Data Source Methods
extension PugCollectionViewController {
    
    private var emptyCell: UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard images.notEmpty else { return emptyCell }
        
        guard let pugCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PugCell", for: indexPath) as? PugCell else {
            return emptyCell
        }
        
        let row = indexPath.row
        
        guard images.isValidIndex(index: row) else {
            LOG.info("Invalid index for image: \(row)")
            return pugCell
        }
        
        let url = images[row]
        
        goLoadImageIntoCell(url: url, cell: pugCell, at: indexPath)
        addLongTapGestureTo(cell: pugCell)
        
        return pugCell
    }
    
    
    private func goLoadImageIntoCell(url: URL, cell: PugCell, at indexPath: IndexPath) {
        
        cell.pugPhoto.image = nil
        
        async.addOperation { [weak self, weak cell] in
            
            guard let `self` = self else { return }
            guard let cell = cell else { return }
            
            guard let data = try? Data(contentsOf: url) else {
                LOG.error("Failed to load data from URL \(url)")
                return
            }
            
            guard let image = UIImage(data: data) else {
                LOG.error("Failed to load image from data at \(url)")
                return
            }
            
            self.main.addOperation {
                
                let animations = {
                    cell.pugPhoto.image = image
                }
                
                UIView.transition(with: cell.pugPhoto, duration: 0.7, options: .transitionCrossDissolve, animations: animations, completion: nil)
            }
        }
    }
    
    private func addLongTapGestureTo(cell: PugCell) {
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(copyImageToClipboard))
        cell.addGestureRecognizer(gesture)
    }
    
    func copyImageToClipboard(gestureReconizer: UILongPressGestureRecognizer) {
        
        guard let collectionView = collectionView else { return }
        
        let locationOnScreen = gestureReconizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: locationOnScreen) else { return }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PugCell {
            
            if let image = cell.pugPhoto?.image {
                
                UIPasteboard.general.image = image
            }
        }
    }
}

//MARK: Layouts
extension PugCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (self.view.frame.size.width / 2) - 10
        return CGSize(width: width, height: width)

    }
    
}

//MARK: On scrolling ended
extension PugCollectionViewController {
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.atTheBottom {
            LOG.info("Loading new pugs since scrolled to bottom")
            self.loadPugs()
        }
    }
    
}

//MARK: Extensions
fileprivate extension Array {
    
    var notEmpty: Bool { return !isEmpty }
    
    func isValidIndex(index: Int) -> Bool {
        
        if index < 0 {
            return false
        }
        
        return index < count
    }
}
