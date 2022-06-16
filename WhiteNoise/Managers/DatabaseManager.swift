//
//  DatabaseManager.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 13.06.2022.
//

import CoreData


final class DatabaseManager {
    
    
    static let shared = DatabaseManager()
    
    let persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "MixDataModel")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     }()
    
    private let context: NSManagedObjectContext!
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    func getContext() -> NSManagedObjectContext {
        context
    }
    
    func save(mixName: String, sounds: [Sound] , completion: (_ success: Bool, _ error: Error?)->() = {success,error in }) {
        let mixModel = MixModel(context: context)
        mixModel.name = mixName
        createSoundModels(sounds: sounds, for: mixModel)
        save(completion: completion)
    }

    func save(completion: (_ success: Bool, _ error: Error?)->() = {success,error in }) {
        do {
            try context.save()
            completion(true, nil)
        } catch(let error) {
            completion(false, error)
        }
    }
    
    
    private func createSoundModels(sounds: [Sound], for mix: MixModel) {
        return sounds.forEach { sound in
            let soundModel = SoundModel(context: context)
            soundModel.name = sound.name
            soundModel.volume = sound.volume
            soundModel.mix = mix
            mix.addToSounds(soundModel)
        }
    }
    
}
