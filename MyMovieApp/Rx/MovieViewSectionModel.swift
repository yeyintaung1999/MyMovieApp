import Foundation
import RxDataSources
import RxSwift

enum SectionItems {
    case upcomingMovieSection( items: [MovieResult])
    case popularMovieSection( items: [MovieResult])
    case popularSerieSection( items: [SerieResult])
    case genreListSection( items: [GenreResult])
}

enum HomeViewSectionModel: SectionModelType {
    
    typealias Item = SectionItems
    
    case movieResult(items: [SectionItems])
    case serieResult(items: [SectionItems])
    case genreResult(items: [SectionItems])
    
    var items: [SectionItems] {
        switch self {
            case .movieResult(let items):
                return items
            case .serieResult(let items):
                return items
            case .genreResult(let items):
                return items
        }
    }
    
    init(original: HomeViewSectionModel, items: [SectionItems]) {
        switch original {
            case .movieResult(let items):
                self = .movieResult(items: items)
            case .serieResult(let items):
                self = .serieResult(items: items)
            case .genreResult(let items):
                self = .genreResult(items: items)
        }
    }

}
