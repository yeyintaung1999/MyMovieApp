//
//  GenreVO.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import Foundation
import UIKit

class GenreVO {
    var id: Int = 0
    var name: String = ""
    var isSelected: Bool = false
    
    init(id: Int, name: String, isSelected: Bool){
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}
