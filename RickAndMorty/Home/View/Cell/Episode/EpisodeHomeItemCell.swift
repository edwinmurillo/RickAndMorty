//
//  EpisodeHomeItemCell.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 11/06/23.
//

import UIKit

class EpisodeHomeItemCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstInfoTitleLabel: UILabel!
    @IBOutlet private weak var firstInfoDescriptionLabel: UILabel!
    @IBOutlet private weak var secondInfoTitleLabel: UILabel!
    @IBOutlet private weak var secondInfoDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func updateCell(info: EpisodeInfo?) {
        guard let info else { return }
        titleLabel.text = info.name
        
        firstInfoTitleLabel.text = "Episode:"
        firstInfoDescriptionLabel.text = info.episode
        secondInfoTitleLabel.text = "On air:"
        secondInfoDescriptionLabel.text = info.airDate
    }
}

private extension EpisodeHomeItemCell {
    func setup() {
        backgroundColor = .clear
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 12

        titleLabel.font = .init(name: "Impact", size: 25)
        titleLabel.textColor = .init(named: "cellLabelColor")
        
        firstInfoTitleLabel.font = .init(name: "Rockwell", size: 14)
        firstInfoTitleLabel.textColor = .init(named: "cellLabelColor")
        firstInfoDescriptionLabel.font = .init(name: "Rockwell", size: 12)
        firstInfoDescriptionLabel.textColor = .init(named: "cellLabelColor")
        
        secondInfoTitleLabel.font = .init(name: "Rockwell", size: 14)
        secondInfoTitleLabel.textColor = .init(named: "cellLabelColor")
        secondInfoDescriptionLabel.font = .init(name: "Rockwell", size: 12)
        secondInfoDescriptionLabel.textColor = .init(named: "cellLabelColor")
    }
}
