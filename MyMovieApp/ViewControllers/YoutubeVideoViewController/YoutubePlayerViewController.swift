//
//  YoutubePlayerViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 25/12/2022.
//

import UIKit
import YouTubePlayer

class YoutubePlayerViewController: UIViewController {
    
    var stringURL: String? {
        didSet{
            if let stringURL = stringURL {
                //playYoutube(key: stringURL)
            }
        }
    }
    
    @IBOutlet weak var youtubePlayer: YouTubePlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        youtubePlayer.loadVideoURL(URL(string: "https://www.youtube.com/watch?v=\(stringURL!)")!)
        youtubePlayer.play()
        
        
    }

    func playYoutube(key: String){
        youtubePlayer.loadVideoURL(URL(string: "https://www.youtube.com/watch?v=\(key)")!)
        youtubePlayer.play()
    }

}
