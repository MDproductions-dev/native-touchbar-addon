//
//  BrowserMessager.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 08/11/2020.
//

import Foundation

class BrowserCommunication {
  
  func processMessage(_ message: String) {
    // Process message
  }
  
  func waitForCommands() {
    DispatchQueue.global(qos: .background).async {
      let input = FileHandle.standardInput
      
      var data = Data()
      
      while true {
        // Get at least the message size (4 bytes)
        while data.count < 4 {
          data.append(input.availableData)
        }
        
        // Parse size
        let messageSize: Int = data.withUnsafeBytes {
          Int( UInt32(littleEndian: $0.load(as: UInt32.self)) )
        }
        
        // Remove parsed size bytes from 'data'
        if data.count == 4 {
          data = Data()
        } else {
          data = data.advanced(by: 4)
        }
        
        // Read at least the whole message
        while data.count < messageSize {
          data.append(input.availableData)
          NSLog("Received body data: %i", data.count)
        }
        
        // Parse the message at utf8
        let message = String(data: data.prefix(messageSize), encoding: .utf8)!
        
        // Remove parsed message from 'data'
        if data.count == messageSize {
          data = Data()
        } else {
          data = data.advanced(by: messageSize)
        }
        
        // Process the parsed message
        self.processMessage(message)
      }
      
    }
  }
  
}
