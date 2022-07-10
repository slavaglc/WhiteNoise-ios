//
//  MixModel+CoreDataProperties.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 10.07.2022.
//
//

import Foundation
import CoreData


extension MixModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MixModel> {
        return NSFetchRequest<MixModel>(entityName: "MixModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var minutes: Int16
    @NSManaged public var sounds: NSOrderedSet?

}

// MARK: Generated accessors for sounds
extension MixModel {

    @objc(insertObject:inSoundsAtIndex:)
    @NSManaged public func insertIntoSounds(_ value: SoundModel, at idx: Int)

    @objc(removeObjectFromSoundsAtIndex:)
    @NSManaged public func removeFromSounds(at idx: Int)

    @objc(insertSounds:atIndexes:)
    @NSManaged public func insertIntoSounds(_ values: [SoundModel], at indexes: NSIndexSet)

    @objc(removeSoundsAtIndexes:)
    @NSManaged public func removeFromSounds(at indexes: NSIndexSet)

    @objc(replaceObjectInSoundsAtIndex:withObject:)
    @NSManaged public func replaceSounds(at idx: Int, with value: SoundModel)

    @objc(replaceSoundsAtIndexes:withSounds:)
    @NSManaged public func replaceSounds(at indexes: NSIndexSet, with values: [SoundModel])

    @objc(addSoundsObject:)
    @NSManaged public func addToSounds(_ value: SoundModel)

    @objc(removeSoundsObject:)
    @NSManaged public func removeFromSounds(_ value: SoundModel)

    @objc(addSounds:)
    @NSManaged public func addToSounds(_ values: NSOrderedSet)

    @objc(removeSounds:)
    @NSManaged public func removeFromSounds(_ values: NSOrderedSet)

}

extension MixModel : Identifiable {

}
