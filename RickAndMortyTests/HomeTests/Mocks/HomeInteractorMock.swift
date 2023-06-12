//
//  HomeInteractorMock.swift
//  RickAndMortyTests
//
//  Created by edwin.murillo on 11/06/23.
//

import RxTest
import RxSwift
@testable import RickAndMorty

class HomeInteractorMock: HomeInteractorProtocol {
    private var dataSubject = PublishSubject<CollectionInfo>()
    var dataObservable: Observable<CollectionInfo> {
        return dataSubject.asObservable()
    }
    
    func getInfo(for searchType: SearchType, with filter: String) {
        
        let characterInfo = CharacterCollectionInfo()
        characterInfo.nextPage = "https://rickandmortyapi.com/api/character/?page=2"
        characterInfo.count = 2
        characterInfo.results = [CharacterInfo(), CharacterInfo()]
        dataSubject.onNext(characterInfo)
    }
    
    func getNextPage(for searchType: SearchType, with page: String) {
        
        let characterInfo = CharacterCollectionInfo()
        characterInfo.nextPage = "https://rickandmortyapi.com/api/character/?page=3"
        characterInfo.count = 3
        characterInfo.results = [CharacterInfo(), CharacterInfo(), CharacterInfo()]
        dataSubject.onNext(characterInfo)
    }
}
