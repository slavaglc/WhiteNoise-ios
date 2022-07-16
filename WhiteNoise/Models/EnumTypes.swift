//
//  EnumTypes.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 16.07.2022.
//

import Foundation


enum SettingType {
    enum MixerSetting: String, CaseIterable {
    case renameMix = "SettingsRename"
    case deleteMix = "SettingsDeleteMix"
    }
    
    enum AppSettings: String, CaseIterable {
        case contactUs = "SettingsContactUs"
        case inviteFriend = "SettingsInviteFriend"
        case privacyPolicy = "SettingsPrivacyPolicy"
        case rateUs = "SettingsRateUs"
        case setReminder = "SettingsSetReminder"
    }
}
