//
//  Routes.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 23/12/2022.
//

import Foundation
import UIKit

extension UIViewController{
    func navigateToSearchViewController(){
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMovieDetailViewController(id: Int){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.movieID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSerieDetailViewController(id: Int){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: SerieDetailViewController.self)) as? SerieDetailViewController else {return}
        vc.serieID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToCastDetailViewController(id: Int){
        print("tapped cast detail")
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CastDetailViewController.self)) as? CastDetailViewController else {return}
        vc.castID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
