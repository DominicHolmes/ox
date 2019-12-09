//
//  ViewController.swift
//  ox
//
//  Created by Dominic Holmes on 11/23/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import UIKit

protocol PlayerControl: class {
    func playSong(with uri: String)
    func pause()
}

protocol PlayerDelegate: class {
    func didUpdatePlayer(with player: SPTAppRemotePlayerState)
    func didConnect()
    func didDisconnect(with error: Error?)
    func didFailConnection(with error: Error?)
    func didFetch(_ image: UIImage, forTrackURI: String)
}

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var playlistLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var isPaused = true
    weak var playerControl: PlayerControl? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.viewControllerDelegate = self
            self.playerControl = sd
        }
        
        albumImageView.layer.cornerRadius = 10.0
        albumImageView.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func didTogglePause() {
        if isPaused {
            playerControl?.playSong(with: "20I6sIOMTCkB6w7ryavxtO")
        } else {
            playerControl?.pause()
        }
        updatePauseButton()
    }
    
    func updatePauseButton() {
        let systemName = isPaused ? "play.circle.fill" : "pause.circle.fill"
        pauseButton.setBackgroundImage(UIImage(systemName: systemName), for: UIControl.State())
    }
}

extension PlayerViewController: PlayerDelegate {
    func didFetch(_ image: UIImage, forTrackURI: String) {
        albumImageView.image = image
    }
    
    func didDisconnect(with error: Error?) {
        print("disconnected")
    }
    
    func didFailConnection(with error: Error?) {
        print("failed connection")
    }
    
    func didConnect() {
        print("connected")
    }
    
    func didUpdatePlayer(with player: SPTAppRemotePlayerState) {
        print(player.isPaused ? "⏸" : "▶️")
        print(player.contextTitle)
        print(player.playbackPosition)
        print(player.track.name)
        trackLabel.text = player.track.name
        playlistLabel.text = player.contextTitle
        artistLabel.text = player.track.artist.name
        albumLabel.text = player.track.album.name
        //albumImageView.image = player.track
        
        isPaused = player.isPaused
        updatePauseButton()
    }
    
}
