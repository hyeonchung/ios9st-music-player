//
//  TrackCollectionViewHeader.swift
//  ios9StMusicApp
//
//  Created by 정현준 on 2021/07/07.
//

import UIKit
import AVFoundation

class TrackCollectionViewHeader: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!

    var item: AVPlayerItem?
    var tapHandler: ((AVPlayerItem) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        artistName.textColor = UIColor.systemGray2
    }

    // 헤더뷰 정보 업데이트
    func updateHeaderUI(item: Track?) {
        // TODO: 곡정보 표시하기

        guard let track = item else {return}

        thumbnailImageView.image = track.artwork
        albumTitle.text = track.albumName
        artistName.text = track.artist
    }

    // MARK: 탭했을 때 변화 =
    @IBAction func cardTapped(_ sender: UIButton) {
        guard let track = item else {return}
        tapHandler?(track)
    }
}
