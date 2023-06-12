//
//  HomeViewController.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 9/06/23.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet private weak var topStackView: UIStackView!
    @IBOutlet private weak var topContainerView: UIView!
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var bottomContainerView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var textFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private weak var dismissSearchButton: UIButton!
    private var searchTextFieldLeadingConstant: CGFloat = 0
    private let dataSource = HomeDataSource()
    private let disposeBag = DisposeBag()
    private var presenter: HomePresenter?
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        let firstTab = SearchType.allCases.first ?? .character
        self.getInfo(for: firstTab)
    }
    
    func getInfo(for searchType: SearchType, with filter: String = "") {
        titleLabel.text = searchType.rawValue.uppercased()
        presenter?.getInfo(for: searchType)
    }
}

private extension HomeViewController {
    func setup() {
        dataSource.delegate = presenter
        view.backgroundColor = .init(named: "customBackgroundColor")

        let characterNib = UINib(nibName: "HomeItemCell",bundle: nil)
        self.collectionView.register(characterNib, forCellWithReuseIdentifier: "homeItemCell")
        
        let episodeNib = UINib(nibName: "EpisodeHomeItemCell",bundle: nil)
        self.collectionView.register(episodeNib, forCellWithReuseIdentifier: "episodeHomeItemCell")
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionFlowLayout.minimumLineSpacing = 42

        let topInset = topContainerView.bounds.height + 21
        let bottomInset = bottomContainerView.bounds.height + 21
        collectionView.contentInset = UIEdgeInsets(top: topInset,
                                                   left: 21,
                                                   bottom: bottomInset,
                                                   right: 21)
        
        bottomContainerView.backgroundColor = .init(named: "customBackgroundColor")?.withAlphaComponent(0.95)
        bottomContainerView.layer.borderColor = UIColor.separator.cgColor
        bottomContainerView.layer.borderWidth = 0.5
        
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 10
        
        settingsButton.tintColor = .init(named: "customLabelColor")
        searchButton.tintColor = .init(named: "customLabelColor")
        titleLabel.font = .init(name: "Impact", size: 33)
        titleLabel.textColor = .init(named: "customLabelColor")
        topContainerView.backgroundColor = .init(named: "customBackgroundColor")?.withAlphaComponent(0.95)
        topContainerView.layer.borderColor = UIColor.separator.cgColor
        topContainerView.layer.borderWidth = 0.5
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.enablesReturnKeyAutomatically = true
        searchTextField.backgroundColor = .init(named: "customBackgroundColor")
        searchTextField.layer.cornerRadius = 20
        searchTextField.alpha = 0
        searchTextField.placeholder = "Type Anything!!!"
        
        setupButtons()
        bind()
    }
    
    func setupButtons() {
        for type in SearchType.allCases {
            let button = createButton(for: type)
            bottomStackView.addArrangedSubview(button)
        }
    }
    
    func createButton(for type: SearchType) -> UIView {
        let button = UIButton()
        button.setTitle(type.rawValue, for: .normal)
        button.titleLabel?.font = .init(name: "Impact", size: 21)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.init(named: "buttonBorderColor")?.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = .init(name: "Impact", size: 33)
        button.setTitleColor(.init(named: "customLabelColor"), for: .normal)
        button.backgroundColor = .init(named: "customBackgroundColor")
        
        button
            .rx.tap.asObservable()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.getInfo(for: type)
            }).disposed(by: disposeBag)
        
        
        return button
    }
    
    func bind() {
        presenter?.dataObservable
            .subscribe(onNext: { [weak self] homeData in
                guard let self else { return }
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        bindButtons()
    }
    
    func bindButtons() {
        searchButton
            .rx.tap.asObservable()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.shouldHideSearchField(mustHide: false)
            }).disposed(by: disposeBag)
        
        dismissSearchButton
            .rx.tap.asObservable()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.shouldHideSearchField(mustHide: true)
            }).disposed(by: disposeBag)
    }
    
    func shouldHideSearchField(mustHide: Bool) {
        searchTextField.isHidden = false
        searchTextFieldLeadingConstant = settingsButton.bounds.width + titleLabel.bounds.width

        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self else { return }
            self.searchTextField.alpha = mustHide ? 0 : 1
            let leadingValue = mustHide ? 0 : self.searchTextFieldLeadingConstant
            self.textFieldLeadingConstraint.constant = -leadingValue
            self.view.layoutIfNeeded()

        }) { [weak self] _ in
            guard let self else { return }
            self.searchTextField.isHidden = mustHide
            self.dismissSearchButton.isHidden = mustHide
            if mustHide { self.searchTextField.resignFirstResponder() } else { self.searchTextField.becomeFirstResponder() }
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.searchInfo(with: textField.text ?? "")
        shouldHideSearchField(mustHide: true)
        return true
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = presenter?.items[indexPath.row] else { return }
        let nav = self.navigationController
        presenter?.showDetail(with: item, withNavigation: nav)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if presenter?.items[indexPath.row] is CharacterInfo {
            let width = collectionView.bounds.size.width / 2.5
            let height = width * 4 / 3
            return CGSize(width: width, height: height)
        } else if presenter?.items[indexPath.row] is EpisodeInfo {
            let width = collectionView.bounds.size.width - 50
            let height: CGFloat = 110
            return CGSize(width: width, height: height)
        }
        
        return .zero
    }
}
