//
//  HomeItemCell.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 10/06/23.
//

import UIKit

class HomeItemCell: UICollectionViewCell {
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var blurBackgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var primaryInfoLabel: UILabel!
    @IBOutlet private weak var secondaryInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func updateCell(info: CharacterInfo?) {
        guard let info else { return }
        titleLabel.text = info.name
        primaryInfoLabel.text = "Status: \(info.status)"
        secondaryInfoLabel.text = "Species: \(info.species)"
        
        if let thumbnailURL = info.thumbnail {
            mainImageView.downloaded(from: thumbnailURL)
        }
    }

}

private extension HomeItemCell {
    func setup() {
        backgroundColor = .clear
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.separator.cgColor
        layer.cornerRadius = 12

        titleLabel.font = .init(name: "Impact", size: 16)
        titleLabel.textColor = .init(named: "cellLabelColor")
        primaryInfoLabel.font = .init(name: "Rockwell", size: 12)
        primaryInfoLabel.textColor = .init(named: "cellLabelColor")
        secondaryInfoLabel.font = .init(name: "Rockwell", size: 12)
        secondaryInfoLabel.textColor = .init(named: "cellLabelColor")
        
        blurBackgroundView.backgroundColor = .init(named: "customBackgroundColor")?.withAlphaComponent(0.95)
        blurBackgroundView.layer.borderColor = UIColor.separator.cgColor
        blurBackgroundView.layer.cornerRadius = 8
        blurBackgroundView.layer.borderWidth = 0.5
        
        mainImageView.contentMode = .scaleAspectFill
    }
}

extension UIImageView {
    func downloaded(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
