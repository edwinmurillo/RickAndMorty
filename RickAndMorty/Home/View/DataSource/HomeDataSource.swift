//
//  HomeDataSource.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 10/06/23.
//

import UIKit

protocol HomeDataSourceDelegate: AnyObject {
    var items: [Info] { get }
    var currentTab: SearchType? { get }
    func getNextPage()
}

class HomeDataSource: NSObject, UICollectionViewDataSource {
    weak var delegate: HomeDataSourceDelegate?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        checkForNextPage(with: indexPath.row)
        
        if let data = delegate?.items[indexPath.row] as? CharacterInfo {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeItemCell", for: indexPath) as? HomeItemCell
            cell?.updateCell(info: data)
            return cell ?? UICollectionViewCell()
        } else if let data = delegate?.items[indexPath.row] as? EpisodeInfo {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeHomeItemCell", for: indexPath) as? EpisodeHomeItemCell
            cell?.updateCell(info: data)
            return cell ?? UICollectionViewCell()
        }
        
        return UICollectionViewCell()
    }
    
    func checkForNextPage(with currentItem: Int) {
        guard let totalItems = delegate?.items.count, currentItem > totalItems - 5 else { return }
        delegate?.getNextPage()
    }
}


