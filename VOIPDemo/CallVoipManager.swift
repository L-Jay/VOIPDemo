//
//  CallVoipManager.swift
//  VOIPDemo
//
//  Created by 崔志伟 on 2021/8/11.
//

import UIKit
import CallKit


class CallVoipManager: NSObject, CXProviderDelegate {
    static let manager = CallVoipManager()
    let provider: CXProvider
    
    private override init() {
        let config: CXProviderConfiguration = CXProviderConfiguration(localizedName: "Test Voip")
        config.ringtoneSound = "voip_incoming_ring.mp3"
        config.supportsVideo = true
        config.maximumCallGroups = 1
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.phoneNumber]
        if let icon = UIImage(named: "icon-40") {
            config.iconTemplateImageData = icon.pngData()
        }
        
        provider = CXProvider(configuration: config)
        
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    func providerDidReset(_ provider: CXProvider) {
        
    }
}
