import Foundation
import RxSwift

enum HTTPServiceError: Error {
    case invalidUrl
    case invalidResponse
}

protocol HTTPServiceType {
    func get<T: Decodable>(url: String, responseType: T.Type) -> Single<Result<T, Error>>
}

class HTTPService: HTTPServiceType {
    func get<T: Decodable>(url: String, responseType: T.Type) -> Single<Result<T, Error>> {
        guard let url = URL(string: url) else {
            return .just(.failure(HTTPServiceError.invalidUrl))
        }

        let request = URLRequest(url: url)

        return URLSession.shared.rx
            .data(request: request)
            .map { data in
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    return .success(response)
                } catch {
                    return .failure(HTTPServiceError.invalidResponse)
                }
            }
            .observe(on: MainScheduler.asyncInstance)
            .asSingle()
    }
}
