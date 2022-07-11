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
    
    func getSounds(from mixModel: MixModel) -> [Sound] {
        let sounds = Sound.getAllSounds()
        var soundsDict: [String: Float] = [:]
        let mixSoundsArray = mixModel.sounds!.array as! [SoundModel]
        mixSoundsArray.forEach { soundModel in
            soundsDict[soundModel.name!] = soundModel.volume
        }
        let filtredSounds = sounds.filter {
            soundsDict.keys.contains($0.name)
        }
        
        filtredSounds.forEach { sound in
            sound.volume = soundsDict[sound.name] ?? 0.5
        }
        return filtredSounds
    }
    
    func getMixes()  -> [MixModel] {
       let mixFetchRequest = MixModel.fetchRequest()
        do {
            let mixList = try context.fetch(mixFetchRequest)
            return mixList
        } catch(let error) {
            print(error.localizedDescription)
        }
        return []
    }
    
    func delete(mixModel: MixModel, completion: ()->() = {}) {
             do {
                 mixModel.sounds?.forEach { soundModel in
                     guard let soundModel = soundModel as? SoundModel else { return }
                     context.delete(soundModel)
                 }
                 context.delete(mixModel)
                 try context.save()
                 completion()
             } catch(let error) {
                 print(error.localizedDescription)
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
