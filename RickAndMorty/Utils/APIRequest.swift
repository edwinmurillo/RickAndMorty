//
//  APIRequest.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 9/06/23.
//

import Alamofire
import CryptoKit
import RxSwift
import RxCocoa

final class APIRequest {
    private let baseURL = "https://rickandmortyapi.com/api/"
    private let filter = "/?name="
    private var responseSubject = PublishSubject<([String: Any], SearchType)>()
    var responseObservable: Observable<([String: Any], SearchType)> {
        return responseSubject.asObservable()
    }
    
    func getInfo(for searchType: SearchType, url: String = "", with parameter: String = "") {
        let filterBy = parameter.isEmpty ? "" : filter + parameter
        let actualURL = baseURL + url.lowercased() + filterBy
        makeRequest(for: searchType, url: actualURL)
    }
    
    func getNextPage(for searchType: SearchType, url: String = "") {
        makeRequest(for: searchType, url: url)
    }
    
    func makeRequest(for searchType: SearchType, url: String = "") {
        let request = AF.request(url)
        request.responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                guard let self,
                      let value = value as? [String: Any]
                else { return }
                self.responseSubject.onNext((value, searchType))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
