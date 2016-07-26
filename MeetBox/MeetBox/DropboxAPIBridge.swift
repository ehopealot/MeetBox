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
    
    static var folderIds:[String:String] = [:]
    
    static func setupWithAppKey(appKey: NSString) {
        Dropbox.setupWithAppKey(appKey as String)
        if (Dropbox.authorizedClient != nil) {
            fetchSharedFolderIds()
        }
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
                fetchSharedFolderIds()
            case .Error(let error, let description):
                print("Error \(error): \(description)")
            }
        }
    }
    
    static func fetchSharedFolderIds() {
        Dropbox.authorizedClient!.sharing.listFolders().response { (result: (Sharing.ListFoldersResult)?, ce: CallError<(Void)>?) in
            if (ce == nil) {
                for res in result!.entries {
                    folderIds[res.name] = res.sharedFolderId
                }
            } else {
                print("Error \(ce)")
            }
        }
    }
    
    static func createSharedFolderWithName(folderName: NSString, callback: ((Bool) -> (Void))) {
        let folderPath = "/MeetBox/\(folderName as String)";
        Dropbox.authorizedClient!.files.createFolder(path: folderPath).response { (meta: (Files.FolderMetadata)?, ce: CallError<(Files.CreateFolderError)>?) in
            if (ce != nil) {
                print("Error \(ce)")
                return
            }
            Dropbox.authorizedClient!.sharing.shareFolder(path: folderPath).response({ (result: (Sharing.ShareFolderLaunch)?, ce: CallError<(Sharing.ShareFolderError)>?) in
                if (ce == nil) {
                    let dict = SerializeUtil.prepareJSONForSerialization(Sharing.ShareFolderLaunchSerializer().serialize(result!))
                    folderIds[folderName as String] = dict["shared_folder_id"] as? String
                    callback(true)
                } else {
                    callback(false)
                }
            })
        }
    }
    
    static func isFolderExist(folderName: NSString, callback: ((Bool) -> (Void))) {
        let id = folderIds[folderName as String]
        if (id == nil) {
            callback(false)
            return
        }
        Dropbox.authorizedClient!.sharing.getFolderMetadata(sharedFolderId: id!).response { (meta: (Sharing.SharedFolderMetadata)?, ce: CallError<(Sharing.SharedFolderAccessError)>?) in
            let folderExist = (ce == nil && meta != nil);
            if (ce == nil) {
                folderIds[folderName as String] = meta?.sharedFolderId;
            } else {
                print("Error \(ce)")
            }
            callback(folderExist)
        }
    }
    
    static func addFolderMemebers(folderName: NSString, members: NSArray) {
        let folderId = folderIds[folderName as String]
        var addMembers = Array<Sharing.AddMember>()
        if (folderId != nil) {
            if let array = members as? [String] {
                for email in array {
                    let addMember = Sharing.AddMember(member: Sharing.MemberSelector.Email(email), accessLevel: Sharing.AccessLevel.Editor)
                    addMembers.append(addMember)
                }
            }
        } else {
            print("Shared folder \(folderName) not found.")
        }
        
        Dropbox.authorizedClient!.sharing.addFolderMember(sharedFolderId: folderId!, members: addMembers).response { (_: (Void)?, ce: CallError<(Sharing.AddFolderMemberError)>?) in
            if (ce != nil) {
                print("Add folder member error \(ce)")
            } else {
                print("Shared folder \(folderName) with \(members)")
            }
        }
    }

}