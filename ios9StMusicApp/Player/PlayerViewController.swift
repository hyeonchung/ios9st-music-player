//
//  PlayerViewController.swift
//  ios9StMusicApp
//
//  Created by 정현준 on 2021/07/14.
//

import UIKit
import Foundation
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistAlbumLabel: UILabel!
    
    @IBOutlet weak var playControlButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var minimizeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!

    let simplePlayer = SimplePlayer.shared

    var timeObserver: Any?
    var isSeeking: Bool = false
    var isMuted: Bool = false
    var isLiked: Bool = false
    
    func like() {
        isLiked = true
    }
    func unlike() {
        isLiked = false
    }

    // MARK: 플레이어 실행시: 자동으로 재생, 재생버튼 업데이트, 시간 업데이트(updateTime, TimeObserver) (O)
    override func viewDidLoad() {
        super.viewDidLoad()
        simplePlayer.play()
        updatePlayButton()
        updateLikeButton()
        updateTime(time: CMTime.zero)
        timeObserver = simplePlayer.addPeriodicTimeObserver(forInterval:CMTime(seconds: 1, preferredTimescale: 10), queue:DispatchQueue.main, using:{time in self.updateTime(time:time)})

        // MARK: 볼륨 상태 업데이트 (O)
        volumeSlider.value = 0.5
        volumeSlider.maximumValue = 1.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTrackInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        simplePlayer.pause()
        simplePlayer.replaceCurrentItem(with: nil)
    }
    // MARK: 플레이어 최소화 버튼


    // MARK: 시간 슬라이더 드래그 가능하도록 설정 (O)
    @IBAction func beginDrag(_ sender: UISlider) {
        isSeeking = true
    }

    @IBAction func endDrag(_ sender: UISlider) {
        isSeeking = false
    }

    // MARK: 시간 변화 탐지(O)
    @IBAction func seek(_ sender: UISlider) {
        guard let currentItem = simplePlayer.currentItem else {return}

        let position = Double(sender.value)
        let seconds = position * currentItem.duration.seconds
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        simplePlayer.seek(to: time)
    }


    // MARK: 볼륨 슬라이드 드래그 가능하도록 설정(O)
    @IBAction func beginVolumeDrag(_ sender: Any) {
        isSeeking = true
    }

    @IBAction func endVolumeDrag(_ sender: Any) {
        isSeeking = false
    }

    // MARK: 볼룸 변화 탐지(O)
    @IBAction func changeVolume(_ sender: UISlider) {
        simplePlayer.currentVolume = Float(volumeSlider.value)
    }

    // MARK: 볼륨 슬라이더 맨 왼쪽 클릭시 음소거 (O)
    @IBAction func muteVolume(_ sender: UIButton) {
        let formerVolume = Float(volumeSlider.value)

        if Float(volumeSlider.value) != 0 {
            volumeSlider.value = 0
            changeVolume(volumeSlider)
            print(simplePlayer.isMuted)
        } else {
            volumeSlider.value = formerVolume
            changeVolume(volumeSlider)
            print(simplePlayer.isMuted)
        }

    }


    // 재생 버튼 클릭 (O)
    @IBAction func togglePlayButton(_ sender: UIButton) {
        if simplePlayer.isPlaying {
            simplePlayer.pause()
        } else {
            simplePlayer.play()
        }
        updatePlayButton()
    }

    // MARK: - 빨리감기, 되감기 버튼 작동
    @IBAction func toggleRewindButton(_ sender: UIButton) {
        
    }

    @IBAction func toggleForwardButton(_ sender: UIButton) {
    }

    // MARK: - 하트 버튼 눌렀을 때 변화 (O)
    @IBAction func changeLikeColor(_ sender: UIButton) {
        if isLiked {
            unlike()
        } else {
            like()
        }
        updateLikeButton()
    }

    // MARK: 하단 버튼 클릭
    // 셔플 버튼 클릭시 배경 회색으로 처리

}




// MARK: 시간 탐색 구현을 위한 수치 산출 (O)
extension PlayerViewController {
    func updateTrackInfo() {
        guard let track = simplePlayer.currentItem?.convertToTrack() else {return}
        thumbnailImageView.image = track.artwork
        titleLabel.text = track.title
        artistAlbumLabel.text = "\(track.artist) - \(track.albumName)"
    }

    // func updateTintColor() {}

    func updateTime(time:CMTime) {
        // MARK: 시간 정보 업데이트 -> 플레이어상에 띄우기 (O)
        currentTimeLabel.text = secondsToString(sec: simplePlayer.currentTime)
        totalDurationLabel.text = "-\(secondsToString(sec: (simplePlayer.totalDurationTime - simplePlayer.currentTime)))"

        if isSeeking == false {
            // 구간을 찾고있지 않은 경우에만 슬라이더 바 업데이트 시키기
            timeSlider.value = Float(simplePlayer.currentTime/simplePlayer.totalDurationTime)
        }
    }

    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else {return "00:00"}
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }

}

// MARK: 컨트롤 부분 (O)
extension PlayerViewController {
    // 재생 버튼 클릭시 변화
    func updatePlayButton() {
        if simplePlayer.isPlaying {
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        }
    }

    // MARK: 좋아요 버튼 클릭시 변화 (보류: 좋아요 표시 목록과 연계)
    func updateLikeButton() {
        if isLiked {
            let configuration = UIImage.SymbolConfiguration(pointSize: 25)
            let image = UIImage(systemName: "heart.fill", withConfiguration: configuration)
            likeButton.setImage(image, for: .normal)
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 25)
            let image = UIImage(systemName: "heart", withConfiguration: configuration)
            likeButton.setImage(image, for: .normal)
        }
        //print(isLiked)
    }
}


// MARK: 하단 아이콘 클릭시 배경 변화
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(backgroundImage, for: state)
    }
}
