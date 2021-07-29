//
//  ExtensionAVPlayerItem.swift
//  ios9StMusicApp
//
//  Created by 정현준 on 2021/07/07.
//
import AVFoundation
import UIKit

// 추가 확장 함수 (TrackManager에 한번에 쓰긴 너무 많아서)

extension AVPlayerItem {
    // 트랙 자체에 있는 메타데이터 (곡명, 가수명, 앨범명, 앨범자켓사진 ...)를 Track 모델로 뽑아줌
    func convertToTrack() -> Track? {
        let metadataList = asset.metadata

        var trackTitle: String?
        var trackArtist: String?
        var trackAlbumName: String?
        var trackArtWork: UIImage?
/*        var trackCreator: String?
        var trackType: String?
        var trackNum: Int?
        var trackYear: Int?
        var trackLyrics: String? */

        for metadata in metadataList {

            if let title = metadata.title {
                trackTitle = title
            }

            if let artist = metadata.artist {
                trackArtist = artist
            }

            if let albumName = metadata.albumName {
                trackAlbumName = albumName
            }

            if let artwork = metadata.artwork {
                trackArtWork = artwork
            }
/*
            if let creator = metadata.creator {
                trackCreator = creator
            }

            if let type = metadata.type{
                trackType = type
            }

            if let num = metadata.num{
                trackNum = num
            }

            if let year = metadata.year {
                trackYear = year
            }

            if let lyrics = metadata.lyrics {
                trackLyrics = lyrics
            } */
        }

        guard let title = trackTitle,
            let artist = trackArtist,
            let albumName = trackAlbumName,
            let artwork = trackArtWork else {
            return nil
        }
            /*
            let creator = trackCreator,
            let type = trackType,
            let num = trackNum,
            let year = trackYear,
            let lyrics = trackLyrics */

        return Track(title: title, artist: artist, albumName: albumName, artwork: artwork)
    }
}

/* convertToTrack을 통해 반환된 값들은 NSObject를 상속하고 NSCopying 프로토콜을 준수함.
   이를 타입 캐스팅하여 사용할 때는 stringValue, numberValue, dateValue, dataValue 프로퍼티를 사용해
   안전하고 쉽게 변환하는 것이 권장된다.
 */

extension AVMetadataItem {
    var title: String? {
        guard let key = commonKey?.rawValue, key == "title" else {
            return nil
        }
        return stringValue
    }

    var artist: String? {
        guard let key = commonKey?.rawValue, key == "artist" else {
            return nil
        }
        return stringValue
    }

    var albumName: String? {
        guard let key = commonKey?.rawValue, key == "albumName" else {
            return nil
        }
        return stringValue
    }

    var artwork: UIImage? {
        guard let key = commonKey?.rawValue, key == "artwork", let data = dataValue, let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
 /*
    var creator: String? {
        guard let key = commonKey?.rawValue, key == "creator" else{
            return nil
        }
        return stringValue
    }

    var type: String? {
        guard let key = commonKey?.rawValue, key == "type" else{
            return nil
        }
        return stringValue
    }

    var num: Int? {
        guard let key = identifier?.rawValue , key == "id3/TRCK" else{
            return nil
        }
        return numberValue as! Int
    }

    var year: Int? {
        guard let key = identifier?.rawValue , key == "id3/TYER" else{
            return nil
        }
        return numberValue as! Int
    }

    var lyrics: String? {
        guard let key = identifier?.rawValue , key == "id3/USLT" else{
            return nil
        }
        return stringValue
    } */
}

// 음악 재생여부 확인
extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
