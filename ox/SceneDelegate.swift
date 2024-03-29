//
//  SceneDelegate.swift
//  ox
//
//  Created by Dominic Holmes on 11/23/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, SPTAppRemoteDelegate {
    
    let spotifyClientID = "08b0baf768084c83818d4dea7b1b57e8"
    let spotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    
    weak var viewControllerDelegate: PlayerDelegate? = nil
    
    static private let kAccessTokenKey = "access-token-key"
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: SceneDelegate.kAccessTokenKey)
            defaults.synchronize()
            print("🔮🔮🔮 GOT AN ACCESS TOKEN: \(accessToken!)")
        }
    }
    
    lazy var spotifyConfiguration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: spotifyRedirectURL
    )
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.spotifyConfiguration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        //appRemote.playerAPI?.delegate = self
        return appRemote
    }()

    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let parameters = appRemote.authorizationParameters(from: url);
        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        } else if let _ = parameters?[SPTAppRemoteErrorDescriptionKey] {
            // Show the error
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        connect()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        appRemote.disconnect()
    }
    
    func connect() {
        appRemote.connect()
    }
    
    // MARK: AppRemoteDelegate
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
        if let error = error {
            debugPrint(error.localizedDescription)
            }
        })
        // Want to play a new track?
               // self.appRemote.playerAPI?.play("spotify:track:13WO20hoD72L0J13WTQWlT", callback: { (result, error) in
               //     if let error = error {
               //         print(error.localizedDescription)
               //     }
               // })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        viewControllerDelegate?.didFailConnection(with: error)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        viewControllerDelegate?.didDisconnect(with: error)
    }
}

extension SceneDelegate: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.viewControllerDelegate?.didUpdatePlayer(with: playerState)
        self.appRemote.imageAPI?.fetchImage(forItem: playerState.track, with: CGSize(width: 2000, height: 2000), callback: { (image, error) in
            if let image = image as? UIImage {
                self.viewControllerDelegate?.didFetch(image, forTrackURI: playerState.track.uri)
            }
        })
    }
}

extension SceneDelegate: PlayerControl {
    func playSong(with uri: String) {
        self.appRemote.authorizeAndPlayURI("spotify:track:\(uri)")
    }
    
    func pause() {
        self.appRemote.playerAPI?.pause({ (result, error) in
            print("🥵⏸")
            dump(error)
            dump(result)
        })
    }
    
    func playSongWith(_ trackId: String) {
        self.appRemote.authorizeAndPlayURI("spotify:track:\(trackId)")
    }
}
