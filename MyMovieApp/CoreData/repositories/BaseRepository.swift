//
//  BaseRepository.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 03/01/2023.
//

import Foundation

class BaseRepository: NSObject {
    
    let rxNetworkAgent = RxNetworkAgent.shared
    
    let coredata = CoreDataStack.shared
}
