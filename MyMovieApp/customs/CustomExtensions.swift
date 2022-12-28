//
//  CustomCodes.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier : String {
        String(describing: self)
    }
}

extension UITableView {
    
    
    
    func registerCell(identifier: String){
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(identifier: String, indexPath: IndexPath)->T{
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return UITableViewCell() as! T
        }
        
        return cell
        
    }
    
}

extension UICollectionViewCell{
    static var identifier: String {
        String(describing: self)
    }
}

extension UICollectionView{
    
    func registerCell(identifier: String){
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(identifier: String, indexPath: IndexPath)->T{
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            return UICollectionViewCell() as! T
        }
        return cell
    }
    
}
