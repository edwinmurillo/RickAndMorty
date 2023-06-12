//
//  HomeInteractor.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 9/06/23.
//

import Foundation
import RxSwift

enum SearchType: String, CaseIterable {
    case character = "Character"
    case episode = "Episode"
}

protocol HomeInteractorProtocol: AnyObject {
    var dataObservable: Observable<CollectionInfo> { get }
    func getInfo(for searchType: SearchType, with filter: String)
    func getNextPage(for searchType: SearchType, with page: String)
}

final class HomeInteractor: HomeInteractorProtocol {
    private let request = APIRequest()
    private let disposeBag = DisposeBag()
    private let decoder = JSONDecoder()
    private var dataSubject = PublishSubject<CollectionInfo>()
    var dataObservable: Observable<CollectionInfo> {
        return dataSubject.asObservable()
    }

    init() {
        setup()
    }
    
    func getInfo(for searchType: SearchType, with filter: String = "") {
        request.getInfo(for: searchType, url: searchType.rawValue, with: filter)
    }
    
    func getNextPage(for searchType: SearchType, with page: String) {
        request.getNextPage(for: searchType, url: page)
    }
}

private extension HomeInteractor {
    func setup() {
        request.responseObservable
            .subscribe(onNext: { [weak self] (requestData, searchType) in
                guard let self else { return }
                switch searchType {
                case .character:
                    if let info = CharacterCollectionInfo(JSON: requestData) {
                        self.dataSubject.onNext(info)
                    }
                case .episode:
                    if let info = EpisodeCollectionInfo(JSON: requestData) {
                        self.dataSubject.onNext(info)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
