//
//  VideoCell.swift
//  Tap Mobile Youtube
//
//  Created by BigWin on 12/7/21.

import UIKit
import youtube_ios_player_helper

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    var videoRenderer: VideoRenderer? {
        didSet {
            playerView.load(withVideoId: videoRenderer!.videoId)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
