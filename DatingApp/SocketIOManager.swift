//
//  SocketIOManager.swift
//  datingapp
//
//  Created by user on 05/10/2016.
//  Copyright © 2016 Dyc Studio. All rights reserved.

import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "52.211.99.13:8080")!, config: NSDictionary(dictionary: ["reconnects": true]))
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
}
