//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 10/06/23.
//

import UIKit
import RxSwift

class CharacterDetailViewController: UIViewController {
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var blurBackgroundView: UIView!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    @IBOutlet private weak var firstInfoTItleLabel: UILabel!
    @IBOutlet private weak var firstInfoDescriptionLabel: UILabel!
    @IBOutlet private weak var secondInfoTitleLabel: UILabel!
    @IBOutlet private weak var secondInfoDescriptionLabel: UILabel!
    @IBOutlet private weak var thirdInfoTitleLabel: UILabel!
    @IBOutlet private weak var thirdInfoDescriptionLabel: UILabel!
    @IBOutlet private weak var fourthInfoTitleLabel: UILabel!
    @IBOutlet private weak var fourthInfoDescriptionLabel: UILabel!
    @IBOutlet private weak var fifthInfoTitleLabel: UILabel!
    @IBOutlet private weak var fifthInfoDescriptionLabel: UILabel!
    
    private let itemInfo: Info
    private let presenter: DetailPresenter
    private let disposeBag = DisposeBag()

    init(presenter: DetailPresenter, itemInfo: Info) {
        self.presenter = presenter
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .init(named: "customLabelColor")

        setup()
    }
}

private extension CharacterDetailViewController {
    func setup() {
        characterNameLabel.font = .init(name: "Impact", size: 60)
        characterNameLabel.numberOfLines = 2
        characterNameLabel.adjustsFontSizeToFitWidth = true
        characterNameLabel.minimumScaleFactor = 0.2
        characterNameLabel.textColor = .init(named: "customLabelColor")
        
        backgroundImageView.contentMode = .scaleAspectFill
        blurBackgroundView.backgroundColor = .init(named: "customBackgroundColor")?.withAlphaComponent(0.80)

        mainImageView.layer.cornerRadius = 12
        mainImageView.contentMode = .scaleAspectFill

        firstInfoTItleLabel.font = .init(name: "Impact", size: 22)
        firstInfoTItleLabel.textColor = .init(named: "customLabelColor")
        firstInfoTItleLabel.text = "Status"
        firstInfoDescriptionLabel.adjustsFontSizeToFitWidth = true
        firstInfoDescriptionLabel.minimumScaleFactor = 0.5
        firstInfoDescriptionLabel.font = .init(name: "Rockwell", size: 15)
        firstInfoDescriptionLabel.textColor = .init(named: "customLabelColor")

        secondInfoTitleLabel.font = .init(name: "Impact", size: 22)
        secondInfoTitleLabel.textColor = .init(named: "customLabelColor")
        secondInfoTitleLabel.text = "Species"
        secondInfoDescriptionLabel.adjustsFontSizeToFitWidth = true
        secondInfoDescriptionLabel.minimumScaleFactor = 0.5
        secondInfoDescriptionLabel.font = .init(name: "Rockwell", size: 15)
        secondInfoDescriptionLabel.textColor = .init(named: "customLabelColor")
        
        thirdInfoTitleLabel.font = .init(name: "Impact", size: 22)
        thirdInfoTitleLabel.textColor = .init(named: "customLabelColor")
        thirdInfoTitleLabel.text = "Gender"
        thirdInfoDescriptionLabel.adjustsFontSizeToFitWidth = true
        thirdInfoDescriptionLabel.minimumScaleFactor = 0.5
        thirdInfoDescriptionLabel.font = .init(name: "Rockwell", size: 15)
        thirdInfoDescriptionLabel.textColor = .init(named: "customLabelColor")
        thirdInfoDescriptionLabel.lineBreakMode = .byCharWrapping
        
        fourthInfoTitleLabel.font = .init(name: "Impact", size: 22)
        fourthInfoTitleLabel.textColor = .init(named: "customLabelColor")
        fourthInfoTitleLabel.text = "Origin"
        fourthInfoDescriptionLabel.adjustsFontSizeToFitWidth = true
        fourthInfoDescriptionLabel.minimumScaleFactor = 0.5
        fourthInfoDescriptionLabel.font = .init(name: "Rockwell", size: 15)
        fourthInfoDescriptionLabel.textColor = .init(named: "customLabelColor")
        fourthInfoDescriptionLabel.lineBreakMode = .byCharWrapping
        
        fifthInfoTitleLabel.font = .init(name: "Impact", size: 22)
        fifthInfoTitleLabel.textColor = .init(named: "customLabelColor")
        fifthInfoTitleLabel.text = "Location"
        fifthInfoDescriptionLabel.adjustsFontSizeToFitWidth = true
        fifthInfoDescriptionLabel.minimumScaleFactor = 0.5
        fifthInfoDescriptionLabel.font = .init(name: "Rockwell", size: 15)
        fifthInfoDescriptionLabel.textColor = .init(named: "customLabelColor")
        updateCell()
    }
    
    func updateCell() {
        if let itemInfo = itemInfo as? CharacterInfo {
            updateCharacterInfo(with: itemInfo)
        } else if let itemInfo = itemInfo as? EpisodeInfo {
            updateEpisodeInfo(with: itemInfo)
        }
    }
    
    func updateCharacterInfo(with detailData: CharacterInfo) {
        characterNameLabel.text = detailData.name
        if let thumbnailURL = detailData.thumbnail {
            backgroundImageView.downloaded(from: thumbnailURL)
            mainImageView.downloaded(from: thumbnailURL)
        }
        firstInfoDescriptionLabel.text = detailData.status
        secondInfoDescriptionLabel.text = detailData.species
        thirdInfoDescriptionLabel.text = detailData.gender
        fourthInfoDescriptionLabel.text = detailData.origin
        fifthInfoDescriptionLabel.text = detailData.location
    }
    
    func updateEpisodeInfo(with detailData: EpisodeInfo) {
        characterNameLabel.isHidden = true
        backgroundImageView.isHidden = true
        mainImageView.isHidden = true
        blurBackgroundView.isHidden = true
        fourthInfoDescriptionLabel.isHidden = true
        fourthInfoTitleLabel.isHidden = true
        fifthInfoTitleLabel.isHidden = true
        fifthInfoDescriptionLabel.isHidden = true
        
        firstInfoTItleLabel.text = "Name"
        firstInfoDescriptionLabel.text = detailData.name
        secondInfoTitleLabel.text = "Episode"
        secondInfoDescriptionLabel.text = detailData.episode
        thirdInfoTitleLabel.text = "On Air"
        thirdInfoDescriptionLabel.text = detailData.airDate
    }
}
