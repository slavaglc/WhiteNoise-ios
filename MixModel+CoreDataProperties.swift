//
//  MixModel+CoreDataProperties.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 13.06.2022.
//
//

import Foundation
import CoreData


extension MixModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MixModel> {
        return NSFetchRequest<MixModel>(entityName: "SoundModel")
    }

    @NSManaged public var category: String?
    @NSManaged public var imageName: String?
    @NSManaged public var isLocked: Bool
    @NSManaged public var name: String?
    @NSManaged public var trackName: String?
    @NSManaged public var mix: MixModel?

}

extension MixModel : Identifiable {

}
