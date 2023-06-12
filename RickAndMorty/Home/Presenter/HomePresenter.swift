//
//  HomePresenter.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 9/06/23.
//

import RxSwift
import RxCocoa
import UIKit

final class HomePresenter: NSObject, HomeDataSourceDelegate {
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    private let disposeBag = DisposeBag()
    private var dataSubject = PublishSubject<CollectionInfo>()
    var dataObservable: Observable<CollectionInfo> {
        return dataSubject.asObservable()
    }
    private var collectionInfo: CollectionInfo?
    private var lastPageRequested: String?
    var currentTab: SearchType? = .allCases.last
    var items: [Info] = []

    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        super.init()
        bind()
    }
    
    func getInfo(for searchType: SearchType, with filter: String = "") {
        guard currentTab != searchType else { return }
        items = []
        currentTab = searchType
        interactor.getInfo(for: searchType, with: filter)
    }
    
    func showDetail(with item: Info, withNavigation navigation: UINavigationController?) {
        guard let navigation = navigation else { return }
        router.showDetail(with: item, withNavigation: navigation)
    }
    
    func getNextPage() {
        guard let nextPage = collectionInfo?.nextPage, nextPage != lastPageRequested, let currentTab else { return }
        interactor.getNextPage(for: currentTab, with: nextPage)
        lastPageRequested = nextPage
    }
    
    func searchInfo(with filter: String = "") {
        guard let currentTab else { return }
        items = []
        interactor.getInfo(for: currentTab, with: filter)
    }
}

private extension HomePresenter {
    func bind() {
        interactor.dataObservable
            .subscribe(onNext: { [weak self] data in
                self?.handleResponse(with: data)
            })
            .disposed(by: disposeBag)
    }
    
    func handleResponse(with data: Any) {
        if let data = data as? CharacterCollectionInfo {
            self.items += data.results
            self.collectionInfo = data
            self.dataSubject.onNext(data)
        } else if let data = data as? EpisodeCollectionInfo {
            self.items += data.results
            self.collectionInfo = data
            self.dataSubject.onNext(data)
        }
    }
}
