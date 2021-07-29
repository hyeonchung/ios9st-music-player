//
//  PlayerButton.swift
//  ios9StMusicApp
//
//  Created by 정현준 on 2021/07/14.
//
import AVFoundation

class SimplePlayer {

    // MARK: 싱글톤으로 플레이어 만들기

    static let shared = SimplePlayer()
    private let player = AVPlayer()

    var currentTime: Double {
        return player.currentItem?.currentTime().seconds ?? 0
    }

    var totalDurationTime: Double{
        return player.currentItem?.duration.seconds ?? 0
    }

    var isPlaying: Bool {
        return player.isPlaying
    }

    var currentItem: AVPlayerItem? {
        return player.currentItem
    }

    var currentVolume: Float {
        get { return player.volume }
        set { player.volume = newValue }
    }

    var isMuted: Bool {
        get { return player.isMuted }
        set { player.isMuted = player.isMuted }
    }



    init() {}

    func pause() {
        player.pause()
    }

    func play() {
        player.play()
    }

    // MARK: (보류): 반복, 셔플 설정 함수 만들기

    func seek(to time: CMTime) {
        player.seek(to: time)
    }

    func replaceCurrentItem(with item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }

    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
        player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }


}

