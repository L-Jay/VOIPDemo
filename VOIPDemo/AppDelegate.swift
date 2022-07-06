//
//  AppDelegate.swift
//  VOIPDemo
//
//  Created by 崔志伟 on 2021/8/11.
//

import UIKit
import PushKit
import CallKit
import AVFAudio

@main
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        voipRegistration();
        CallVoipManager.manager
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken1 = deviceToken.map { String(format: "%02x", $0) }.joined()
        print(deviceToken1)
    }
    
    func voipRegistration() {
        let mainQueue = DispatchQueue.main
        // Create a push registry object
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        // Set the registry's delegate to self
        voipRegistry.delegate = self
        // Set the push type to VoIP
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        // Register VoIP push token (a property of PKPushCredentials) with server
        let token = pushCredentials.token.description
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: " ", with: "")
        print(token)
        let deviceToken1 = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        let dataStr: Data = Data(deviceToken1.utf8)
        let stringNS = NSData(data: dataStr)
        print(stringNS)
        let deviceToken = pushCredentials.token.reduce("", {$0 + String(format: "%02X", $1) })
        print(deviceToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        // Process the received push
        
        print(payload.dictionaryPayload);
        
//        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
        let uuid = UUID.init()
        
        let update = CXCallUpdate()
        update.supportsHolding = false
        update.localizedCallerName = "test just"
        update.hasVideo = true
        update.remoteHandle = CXHandle(type: .generic, value: "5486")
        CallVoipManager.manager.provider.reportNewIncomingCall(with: uuid, update: update) { error in
            print(error)
        }
        
        
        
//        if let uuidString = payload.dictionaryPayload["UUID"] as? String,
//            let identifier = payload.dictionaryPayload["identifier"] as? String,
//            let uuid = UUID(uuidString: uuidString)
//        {
//            let update = CXCallUpdate()
//            update.callerIdentifier = identifier
//
//            provider.reportNewIncomingCall(with: uuid, update: update) { error in
//                // …
//            }
//        }
    }
}

