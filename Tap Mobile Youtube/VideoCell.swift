//
//  VideoCell.swift
//  Tap Mobile Youtube
//
//  Created by BigWin on 12/7/21.

import UIKit
import youtube_ios_player_helper
import MBProgressHUD

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var playerView: YTPlayerView!
    var progressHUD: MBProgressHUD? = nil
    
    var videoRenderer: VideoRenderer? {
        didSet {
            if let videoId = videoRenderer?.videoId, videoId != oldValue?.videoId {
                if progressHUD != nil {
                    progressHUD?.hide(animated: false)
                    progressHUD?.removeFromSuperview()
                }
                progressHUD = MBProgressHUD.showAdded(to: self.contentView, animated: true)
                playerView.load(withVideoId: videoId)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension VideoCell: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        progressHUD?.hide(animated: true)
        progressHUD?.removeFromSuperview()
        progressHUD = nil
    }
}
