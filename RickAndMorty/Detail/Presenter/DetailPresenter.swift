//
//  DetailPresenter.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 10/06/23.
//

import RxSwift
import RxCocoa

final class DetailPresenter: NSObject {
    private let disposeBag = DisposeBag()
    private var detailVC: CharacterDetailViewController?
    private var dataSubject = PublishSubject<CharacterInfo>()
    var dataObservable: Observable<CharacterInfo> {
        return dataSubject.asObservable()
    }
    
    func showDetail(with item: Info, withNavigation navigation: UINavigationController) {
        detailVC = CharacterDetailViewController(presenter: self, itemInfo: item)
        guard let detailVC else { return }
        navigation.pushViewController(detailVC, animated: true)
    }
}
