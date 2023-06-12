//
//  HomePresenterTests.swift
//  RickAndMortyTests
//
//  Created by edwin.murillo on 11/06/23.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import RickAndMorty

final class HomePresenterTests: XCTestCase {
    
    private typealias SUT = (
        presenter: HomePresenter,
        interactor: HomeInteractorMock,
        router: HomeRouterMock
    )
    private var sut: SUT!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        let router = HomeRouterMock()
        let interactor = HomeInteractorMock()
        let presenter = HomePresenter(interactor: interactor, router: router)
        sut = (presenter: presenter, interactor: interactor, router: router)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testFetchDataNotNil() {
        let testObsevable = scheduler.createObserver(CollectionInfo.self)
        guard let presenter = sut?.presenter else { return }

        presenter
            .dataObservable
            .bind(to: testObsevable)
            .disposed(by: disposeBag)

        sut?.presenter.getInfo(for: .character)

        guard let characterCollectionInfo = testObsevable.events.last?.value.element as? CharacterCollectionInfo else { return }
        XCTAssertNotNil(characterCollectionInfo)
        XCTAssertEqual(characterCollectionInfo.results.count, 2)
    }
    
    func testFetchNextPageDataNotNil() {
        let testObsevable = scheduler.createObserver(CollectionInfo.self)
        guard let presenter = sut?.presenter else { return }

        presenter
            .dataObservable
            .bind(to: testObsevable)
            .disposed(by: disposeBag)

        sut?.presenter.getNextPage()

        guard let characterCollectionInfo = testObsevable.events.last?.value.element as? CharacterCollectionInfo else { return }
        XCTAssertNotNil(characterCollectionInfo)
        XCTAssertEqual(characterCollectionInfo.results.count, 3)
    }
    
    func testShowDetail() {
        let presenter = sut.presenter
        let router = sut.router
        let info = CharacterInfo()

        XCTAssertFalse(router.detailShowed)
        presenter.showDetail(with: info, withNavigation: UINavigationController())
        XCTAssertTrue(router.detailShowed)
    }
}
