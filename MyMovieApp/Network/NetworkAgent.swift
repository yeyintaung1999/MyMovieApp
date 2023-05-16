
import Foundation
import Alamofire
import RxAlamofire
import RxSwift

protocol NetworkAgentProtocol {
    func getUpcomingMovies(completion: @escaping(MDBResult<[MovieResult]>)->())
    func getPopularMovies(completion: @escaping(MDBResult<[MovieResult]>)->())
    func getPopularseries(completion: @escaping(MDBResult<[SerieResult]>)->())
    func getGenreList(completion: @escaping (MDBResult<[GenreResult]>)->())
    func searchMovie(query: String,page: Int, completion: @escaping (MDBResult<[MovieResult]>)->())
    func getMovieDetail(id: Int, completion: @escaping (MDBResult<MovieDetail>)->())
    func getMovieCasts(id: Int, completion: @escaping (MDBResult<[CastResult]>)->())
    func getTrailers(id: Int, completion: @escaping(MDBResult<MovieTrailers>)->())
    func getSerieDetail(id: Int, completion: @escaping (MDBResult<SerieDetail>)->())
    func getSerieCasts(id: Int, completion: @escaping (MDBResult<[CastResult]>)->())
    func getSerieTrailers(id: Int, completion: @escaping (MDBResult<[TrailerResult]>)->())
    func getCastDetail(id: Int, completion: @escaping (MDBResult<CastDetail>)->())
    func getMovieCredit(id: Int, completion: @escaping (MDBResult<[MovieResult]>)->())
}

class NetworkAgent: NetworkAgentProtocol {
    
    static let shared = NetworkAgent()
    private init(){}
    
    func getUpcomingMovies(completion: @escaping(MDBResult<[MovieResult]>)->()) {
        
        AF.request(MDBEndPoint.upcoming(1)).responseDecodable(of: UpcomingMOV.self) { (response) in
            switch response.result {
                case .success(let data):
                    completion(.success(data.results ?? [MovieResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularMovies(completion: @escaping(MDBResult<[MovieResult]>)->()) {
        AF.request(MDBEndPoint.popularMov(1)).responseDecodable (of: UpcomingMOV.self) { response in
            switch response.result {
                case .success(let data):
                    completion(.success(data.results ?? [MovieResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }        }
    }
    
    func getPopularseries(completion: @escaping (MDBResult<[SerieResult]>) -> ()) {
        AF.request(MDBEndPoint.popularSer).responseDecodable(of: PopularSeries.self) { response in
            switch response.result {
                case .success(let data):
                    completion(.success(data.results ?? [SerieResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getGenreList(completion: @escaping (MDBResult<[GenreResult]>)->()){
        AF.request(MDBEndPoint.genreList).responseDecodable(of: Genre.self){ response in
            switch response.result{
                case .success(let data):
                    completion(.success(data.genres ?? [GenreResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func searchMovie(query: String,page: Int, completion: @escaping (MDBResult<[MovieResult]>)->()){
        AF.request(MDBEndPoint.searchMovie(query, page)).responseDecodable(of: UpcomingMOV.self) { response in
            switch response.result {
                case .success(let data):
                    completion(.success(data.results ?? [MovieResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    
    func getMovieDetail(id: Int, completion: @escaping (MDBResult<MovieDetail>)->()){
        AF.request(MDBEndPoint.movieDetail(id)).responseDecodable(of: MovieDetail.self) { response in
            switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieCasts(id: Int, completion: @escaping (MDBResult<[CastResult]>)->()){
        AF.request(MDBEndPoint.movieCasts(id)).responseDecodable(of: Casts.self) { response in
            switch response.result {
                case .success(let data):
                    completion(.success(data.cast ?? [CastResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getTrailers(id: Int, completion: @escaping(MDBResult<MovieTrailers>)->()){
        AF.request(MDBEndPoint.trailer(id)).responseDecodable(of: MovieTrailers.self) { response in
            switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getSerieDetail(id: Int, completion: @escaping (MDBResult<SerieDetail>)->()){
        AF.request(MDBEndPoint.serieDetail(id)).responseDecodable(of: SerieDetail.self) {response in
            switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getSerieCasts(id: Int, completion: @escaping (MDBResult<[CastResult]>)->()){
        AF.request(MDBEndPoint.serieCasts(id)).responseDecodable(of: Casts.self){ response in
            switch response.result {
                case .success(let data):
                    completion(.success(data.cast ?? [CastResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getSerieTrailers(id: Int, completion: @escaping (MDBResult<[TrailerResult]>)->()){
        AF.request(MDBEndPoint.serieTrailer(id)).responseDecodable(of: MovieTrailers.self) { response in
            switch response.result {
                case .success(let data):
                    completion(.success(data.results ?? [TrailerResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getCastDetail(id: Int, completion: @escaping (MDBResult<CastDetail>)->()){
        AF.request(MDBEndPoint.castDetail(id)).responseDecodable(of: CastDetail.self){ response in
            switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieCredit(id: Int, completion: @escaping (MDBResult<[MovieResult]>)->()){
        AF.request(MDBEndPoint.movieCredit(id)).responseDecodable(of: MovieCredit.self) { response in
            switch response.result {
                case .success(let data):
                    completion(.success(data.cast ?? [MovieResult]()))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
}



protocol MDBErrorModel : Decodable {
    var message : String { get }
}


class MDBCommonResponseError : MDBErrorModel {
    var message: String {
        return statusMessage
    }
    
    let statusMessage : String
    let statusCode : Int
    
    enum CodingKeys : String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}

enum MDBResult<T>{
    case success(T)
    case failure(String)
}



/*
 
 Network Error - Different Scenarios
 
    *JSON Serialization Error
    *Wrong URL Error
    *Incorrect Methods
    *Missing Credentials
    *4xx
    *5xx
 
 */

//Customize Error Body

private func handleError<T, E: MDBErrorModel>(
    _ response : DataResponse<T, AFError>,
    _ error : (AFError),
    _ errorBodyType : E.Type
) -> String {
    var respBody : String = ""
    var serverErrorMessage : String?
    var errorBody : E?
    
    if let respData = response.data {
        respBody = String(data: respData, encoding: .utf8) ?? "Empty Response Body"
        
        errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
        serverErrorMessage = errorBody?.message
    }
    
    let respCode : Int = response.response?.statusCode ?? 0
    
    let sourcePath : String = response.response?.url?.absoluteString ?? "no url"
    
    
    //1 - Essential Debug Info
    print(
        """
        ==========================
        URL
        ->\(sourcePath)
        
        Status
        ->\(respCode)
        
        Body
        -> \(respBody)
        
        Underlying Error
        -> \(String(describing: error.underlyingError))
        
        Error Description
        -> \(error.errorDescription!)
        
        =========================
        
        """
        
    )
    
    return serverErrorMessage ?? error.errorDescription ?? "undefined"
    
    
}
