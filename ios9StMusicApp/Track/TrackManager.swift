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
    var songs: [Track] = []

    // MARK: (보류) 상단 헤더뷰 (최근 추가 음악) ... 이 정보도 여기서 생성? 아님 그냥 홈뷰에서 생성?

    // 생성자 정의
    init() {
        let tracks = loadTracks()
        self.tracks = tracks
        self.albums = loadAlbums(tracks: tracks)
        self.songs = loadSongs(tracks: tracks)
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
    func trackAlbum(at index: Int) -> Track? {
        let playerItem = tracks[index]
        let track = playerItem.convertToTrack() // extension~~.swift에서 작성
        return track
    }

    // MARK: track() 함수를 변형하면 곡명을 따로 정렬할 수 있지 않을까? -> 성공!! (O)
    func trackSong(at index: Int) -> Track? {
        let playerItem = songs[index] // extension~~.swift에서 작성
        return playerItem
    }

    // MARK: 불러온 트랙에 대한 앨범 정보를 Album 모델 형식으로 로딩 (상단 collectionView)
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

    // MARK: 불러온 트랙에 대한 노래 정보 로딩 (하단 tableView) (O)
    func loadSongs(tracks: [AVPlayerItem]) -> [Track] {
        let trackList: [Track] = tracks.compactMap{$0.convertToTrack()}
        let sortedTrackList = trackList.sorted { $0.title < $1.title }

        return sortedTrackList
    }
}


/*     init(title: String, artist: String, albumName: String, artwork: UIImage) {
 self.title = title
 self.artist = artist
 self.albumName = albumName
 self.artwork = artwork

 */
