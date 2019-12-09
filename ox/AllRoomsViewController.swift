//
//  AllRoomsViewController.swift
//  ox
//
//  Created by Dominic Holmes on 12/8/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import UIKit

class AllRoomsViewController: UITableViewController {
    
    var rooms: [Room] = [Room(name: "test room", iconName: "hello", color: .systemRed)]
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PlayerSegue", sender: rooms[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.identifier) as! RoomCell
        let room = rooms[indexPath.row]
        cell.labelPrimary.text = room.name
        cell.labelDetail.text = "0 users"
        cell.iconView.image = UIImage(systemName: "music.house.fill")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewRoomSegue", let vc = segue.destination as? NewRoomViewController {
            vc.delegate = self
        } else if segue.identifier == "PlayerSegue", let vc = segue.destination as? PlayerViewController {
            
        }
    }
    
    // Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           rooms.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension AllRoomsViewController: RoomCreationDelegate {
    func didCreate(_ room: Room) {
        rooms.append(room)
        tableView.reloadSections([0], with: .automatic)
    }
    
    func didCancel() {
        // do nothing
    }
}
