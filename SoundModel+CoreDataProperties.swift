//
//  SoundModel+CoreDataProperties.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 14.06.2022.
//
//

import Foundation
import CoreData


extension SoundModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SoundModel> {
        return NSFetchRequest<SoundModel>(entityName: "SoundModel")
    }

    @NSManaged public var volume: Float
    @NSManaged public var name: String?
    @NSManaged public var mix: MixModel?

}

extension SoundModel : Identifiable {

}
