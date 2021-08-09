//
//  Track.swift
//  ios9StMusicApp
//
//  Created by 정현준 on 2021/07/07.
//

import UIKit

// MARK: Model 작성

// 트랙 정보에 대한 모델
struct Track {
    let title: String
    let artist: String
    let albumName: String
    let artwork: UIImage

    // MARK: 장르, 작곡가, 년도도 넣고싶음 (o)
/*    let creator: String
    let type: String
    let num: Int
    let year: Int
    let lyrics: String */

    init(title: String, artist: String, albumName: String, artwork: UIImage) {
        self.title = title
        self.artist = artist
        self.albumName = albumName
        self.artwork = artwork

       /* self.creator = creator
        self.type = type
        self.num = num
        self.year = year
        self.lyrics = lyrics */
    }
}

// 앨범 정보에 대한 모델
// MARK: 이 곡을 추가한 시간도 넣고싶음

struct Album {
    let title: String
    let tracks: [Track]

    var thumbnail: UIImage? {
        return tracks.first?.artwork
    }

    var artist: String? {
        return tracks.first?.artist
    }

    init(title: String, tracks: [Track]) {
        self.title = title
        self.tracks = tracks
    }
}
