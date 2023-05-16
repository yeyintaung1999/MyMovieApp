
import Foundation
import Alamofire

enum MDBEndPoint: URLConvertible {
    case upcoming(_ page: Int)
    case popularMov(_ page: Int)
    case popularSer
    case genreList
    case searchMovie(_ string: String, _ page: Int)
    case movieDetail(_ id: Int)
    case movieCasts(_ id: Int)
    case trailer(_ id: Int)
    case serieDetail(_ id: Int)
    case serieCasts(_ id: Int)
    case serieTrailer(_ id: Int)
    case castDetail(_ id: Int)
    case movieCredit(_ id: Int)
    
    private var baseURL: String{
        return baseurl
    }
    
    var url: URL{
        let urlComponents = NSURLComponents(string: baseURL.appending(apiPath))
        
        if (urlComponents?.queryItems == nil){
            urlComponents!.queryItems = []
        }
        urlComponents!.queryItems!.append(contentsOf: [URLQueryItem(name: "api_key", value: apivalue)])
        return urlComponents!.url!
    }
    
    private var apiPath: String {
        switch self {
            case .upcoming(let page):
                return "/movie/upcoming?page=\(page)"
            case .popularMov(let page):
                return "/movie/popular?page=\(page)"
            case .popularSer:
                return "/tv/popular?"
            case .genreList:
                return "/genre/movie/list?"
            case .searchMovie(let query, let page):
                return "/search/movie?query=\(query)&page=\(page)"
            case .movieDetail(let id):
                return "/movie/\(id)?"
            case .movieCasts(let id):
                return "/movie/\(id)/credits"
            case .trailer(let id):
                return "/movie/\(id)/videos"
            case .serieDetail(let id):
                return "/tv/\(id)?"
            case .serieCasts(let id):
                return "/tv/\(id)/credits"
            case .serieTrailer(let id):
                return "/tv/\(id)/videos"
            case .castDetail(let id):
                return "/person/\(id)"
            case .movieCredit(let id):
                return "/person/\(id)/movie_credits"
        }
    }
    
    func asURL() throws -> URL {
        return url
    }
    
}

