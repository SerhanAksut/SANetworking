
import XCTest

@testable import NetworkCore_Default
@testable import Common
@testable import Helpers

final class NetworkCore_DefaultTests: XCTestCase {
    var baseURL: String!
    var requestLoader: RequestLoader!
    
    override func setUp() {
        baseURL = "https://api.test.com"
        requestLoader = RequestLoader(baseURL: baseURL)
    }
    
    override func tearDown() {
        baseURL = nil
        requestLoader = nil
    }
    
    func test__requestError_when_baseURL_is_empty_string() {
        requestLoader = RequestLoader(baseURL: "")
        let request = Request<Sample>(
            path: "v1/sample/sampleEndpoint",
            httpMethod: .get,
            decoder: { data -> Sample in
                Sample()
            }
        )
        requestLoader.load(request: request) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                let err = error as! RequestError
                XCTAssertEqual(err, .invalidURL("/v1/sample/sampleEndpoint"))
            }
        }
    }
    
//    func test__responseModel_when_response_handled_with_success() {
//        let request = Request<Sample>(
//            path: "/v1/sample/sampleEndpoint",
//            httpMethod: .get,
//            decoder: { data -> Sample in
//                Sample()
//            }
//        )
//
//        requestLoader = RequestLoader(baseURL: baseURL)
//        requestLoader.load(request: request) { result in
//            switch result {
//            case .success(let model):
//                let expectedResult = Sample()
//                XCTAssertEqual(model, expectedResult)
//            case .failure:
//                break
//            }
//        }
//    }
}

extension RequestError: Equatable {
    public static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
