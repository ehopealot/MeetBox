//
//  DropboxAPIBridge.swift
//  MeetBox
//
//  Created by drophack on 7/25/16.
//  Copyright © 2016 Erik Hope. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox

@objc class DropboxAPIBridge : NSObject {
    
    static func setupWithAppKey(appKey: NSString) {
        Dropbox.setupWithAppKey(appKey as String)
    }
    
    static func connectWithDropbox(vc: UIViewController) {
        if (Dropbox.authorizedClient != nil) {
            print("already connected")
        } else {
            Dropbox.authorizeFromController(vc)
        }
    }
    
    static func handleOpenUrl(url: NSURL) {
        if let authResult = Dropbox.handleRedirectURL(url) {
            switch authResult {
            case .Success(let token):
                print("Success! User is logged into Dropbox with token: \(token)")
            case .Error(let error, let description):
                print("Error \(error): \(description)")
            }
        }
    }
    
    static func playWithAPIs() {
        /*
        Dropbox.authorizedClient!.files.getMetadata(path: "/app.js").response({ (meta: (Files.Metadata)?, ce: CallError<(Files.GetMetadataError)>?) in
            print(ce)
        });*/

        /*
        Dropbox.authorizedClient!.files.createFolder(path: "/MeetBox/test1").response { (meta: (Files.FolderMetadata)?, ce: CallError<(Files.CreateFolderError)>?) in
            if (ce == nil) {
                print(meta)
            } else {
                print("Error \(ce)")
            }
        }
        */
        
        /*
        Dropbox.authorizedClient!.files.listFolder(path: "").response { (result:(Files.ListFolderResult)?, ce: CallError<(Files.ListFolderError)>?) in
            if (ce == nil) {
                print(result)
            } else {
                print("Error \(ce)")
            }
        }
        */
    }
    
}