import Alamofire

class APIClient {
    static func fetchGnomes(completion:@escaping (Result<GnomesModel, AFError>)->Void) {
        AF.request(APIServer.testServer.rawValue)
            .responseDecodable { (response: AFDataResponse<GnomesModel>) in
                completion(response.result)
        }
    }
}
