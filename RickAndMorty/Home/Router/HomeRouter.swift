//
//  HomeRouter.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 9/06/23.
//

import Foundation
import UIKit

protocol HomeRouterProtocol: AnyObject {
    func showDetail(with item: Info, withNavigation navigation: UINavigationController)
}

final class HomeRouter: HomeRouterProtocol {
    var detailPresenter: DetailPresenter?
    
    func showDetail(with item: Info, withNavigation navigation: UINavigationController) {
        detailPresenter = DetailPresenter()
        detailPresenter?.showDetail(with: item, withNavigation: navigation)
    }
}
