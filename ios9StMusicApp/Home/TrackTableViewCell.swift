//
//  TrackTableViewCell.swift
//  ios9StMusicApp
//
//  Created by 정현준 on 2021/07/07.
//

import UIKit
import AVFoundation

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var trackThumbNail: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackArtistAlbum: UILabel!

    var item: AVPlayerItem?

    // 곡 정보 표시할 때 곡 제목, 가수-앨범명 타이틀 설정
    override func awakeFromNib() {
        super.awakeFromNib()
        trackArtistAlbum.textColor = UIColor.systemGray2
    }

    // 곡 정보 표시
    func updateTableUI(item: Track?) {
        guard let track = item else {return}
        trackThumbNail.image = track.artwork
        trackTitle.text = track.title
        trackArtistAlbum.text = "\(track.artist) - \(track.albumName)"
    }
}
