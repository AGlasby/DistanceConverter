//
//  DataController.swift
//  12parsecs
//
//  Created by Alan Glasby on 02/04/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class AFGDataController {
    var mainContext: NSManagedObjectContext?
    var writerContext: NSManagedObjectContext?

    var initializationComplete: ((Error?) -> Void)?

    init(completion: @escaping (Error?) -> Void) {
        initializationComplete = completion
        initializeCoreDataStack()
    }

    func initializeCoreDataStack() {

        guard let modelUrl = Bundle.main.url(forResource: "BlogModel", withExtension: "momd") else {
            fatalError("Failed to locate BlogModel.momd in app bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Failed to initialize MOM")
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

        var type = NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType
        writerContext = NSManagedObjectContext(concurrencyType: type)
        writerContext?.persistentStoreCoordinator = psc
        writerContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
        mainContext = NSManagedObjectContext(concurrencyType: type)
        mainContext?.persistentStoreCoordinator = psc


        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            let fileManager = FileManager.default
            guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                fatalError("Failed to resolve documents directory")
            }
            let storeUrl = documentsUrl.appendingPathComponent("BlogModel.sqlite")
            do {
                let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
            } catch let  error {
                assertionFailure("Failed to initialize PSC: \(error)")
                self.initializationComplete?(error)
            }
            DispatchQueue.main.async {
                let notificationName = Notification.Name(INITIALIZED)
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        }
    }


    func saveContext() {
        guard  let main = mainContext else {
            fatalError("Save called before mainContext is initialized")
        }
        main.performAndWait({
            if !main.hasChanges {return}
            do {
                try main.save()
            } catch {
                fatalError("Failed to save mainContext: \(error)")
            }
        })
        guard  let writer = writerContext else {
            fatalError("Save called before writerContext is initialized")
        }
        main.performAndWait({
            if !writer.hasChanges {return}
            do {
                try writer.save()
            } catch {
                fatalError("Failed to save writerContext: \(error)")
            }
        })
    }
}
