//
//  ViewController.swift
//  ios9StMusicApp
//
//  Created by 정현준 on 2021/07/05.
//

import UIKit

class HomeViewController: UIViewController {
    // 트랙 관리 객체 추가
    let trackManager: TrackManager = TrackManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: 1 상단 헤더뷰 (콜렉션뷰)

// MARK: 1-1. 표시할 셀 갯수 / 셀 표시 방법 (가장 최근 추가)
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // 표시할 셀의 갯수 (앨범 단위로 출력)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    // 헤더뷰 셀 표시 방법
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewHeader", for: indexPath) as? TrackCollectionViewHeader else {
            return UICollectionViewCell()
        }

        // MARK: 헤더뷰 데이터 연동 ... trackAlbum 함수 이용 (O)
        let track = trackManager.trackAlbum(at: indexPath.item)
        print("헤더뷰 let track = \(track), indexPath: \(indexPath), indexPath.item: \(indexPath.item)")
        cell.updateHeaderUI(item: track)

        return cell
    }

    // MARK: 1-2. 헤더뷰 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // margin - card(width) - space - width - margin

        let itemSpacing: CGFloat = 10
        let margin: CGFloat = 10
        let width = (collectionView.bounds.width - itemSpacing - margin * 2) / 3
        let height = width + 80

        return CGSize(width: width, height: height)
    }

    // MARK: 1-3. 헤더뷰 어떻게 표시?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 곡 클릭시 플레이어뷰 띄우기
        // 1) Player.storyboard 가져오기
        let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)

        // 2) 해당 스토리보드의 ViewController 가져오기 .. 여기서 identifier는 ViewController의 Identitiy Inspector에 기재된 StoryBoard ID
        guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }

        // 3) trackManager를 통해 곡에 대한 정보를 가져오도록 작성
        let item = trackManager.tracks[indexPath.item]
        playerVC.simplePlayer.replaceCurrentItem(with: item)
        playerVC.modalPresentationStyle = .overFullScreen

        // 4) 정보 띄우기
        present(playerVC, animated:true, completion: nil)
    }
}



// MARK: 2. 하단 음원 리스트 (테이블 뷰)

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: 표시할 셀 개수 / 셀 표시 방법

    // 셀 개수 설정 (곡 기준)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackManager.tracks.count
    }

    // 셀 표시 방법 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        // MARK: 하단 테이블뷰  데이터 연동 ... trackSongs 함수 이용 (O)
        let track = trackManager.trackSong(at: indexPath.item)
        print("테이블뷰 let track = \(track)")
        cell.updateTableUI(item: track)
        return cell
    }

    // 테이블 뷰 클릭시 플레이어 뜸
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)

        guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }

        let item = trackManager.tracks[indexPath.item]
        playerVC.simplePlayer.replaceCurrentItem(with: item)
        playerVC.modalPresentationStyle = .overFullScreen

        present(playerVC, animated:true, completion: nil)
    }
}
