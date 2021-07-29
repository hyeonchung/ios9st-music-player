//
//  TrackManager.swift
//  ios9StMusicApp
//
//  Created by 정현준 on 2021/07/06.
//

import UIKit
import AVFoundation

// 트랙 로딩하기
class TrackManager{
    // 트랙, 앨범 프로퍼티 정의
    var tracks: [AVPlayerItem] = []
    var albums: [Album] = []

    // MARK: (보류) 상단 헤더뷰 (최근 추가 음악) ... 이 정보도 여기서 생성? 아님 그냥 홈뷰에서 생성?

    // 생성자 정의
    init() {
        let tracks = loadTracks()
        self.tracks = tracks
        self.albums = loadAlbums(tracks: tracks)
        // MARK: 여기에다가 최근 추가 음악도 생성해야하나? (보류)

    }

    // 트랙 리스트 로딩: 파일들을 읽어 AVPlayer 목록으로 만든다
    func loadTracks() -> [AVPlayerItem] {
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? []
        let tracks = urls.map { url in
            return AVPlayerItem(url: url)
        }
        return tracks
    }

    // 인덱스 기준으로 트랙 리스트에서 트랙 로딩
    func track(at index: Int) -> Track? {
        let playerItem = tracks[index]
        let track = playerItem.convertToTrack() // extension~~.swift에서 작성
        return track
    }

    // 최근 추가 항목: 불러온 트랙에 대한 앨범 정보를 Album 모델 형식으로 로딩
    func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
        let trackList: [Track] = tracks.compactMap{$0.convertToTrack()}
        let albumDics = Dictionary(grouping: trackList, by: { (track) in track.albumName })
        var albums: [Album] = []
        for (key, value) in albumDics {
            let title = key
            let tracks = value
            let album = Album(title: title, tracks: tracks)
            albums.append(album)
        }
        return albums
    }


}
