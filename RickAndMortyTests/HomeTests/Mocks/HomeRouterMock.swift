//
//  HomeRouterMock.swift
//  RickAndMortyTests
//
//  Created by edwin.murillo on 11/06/23.
//

import UIKit
@testable import RickAndMorty

class HomeRouterMock: HomeRouterProtocol {
    var detailShowed: Bool = false

    func showDetail(with item: Info, withNavigation navigation: UINavigationController) {
        detailShowed = true
    }
}
