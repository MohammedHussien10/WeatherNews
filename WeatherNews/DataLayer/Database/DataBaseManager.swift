//
//  DataBaseManager.swift
//  WeatherNews
//
//  Created by Macos on 27/11/2025.
//

import Foundation
import CoreData

final class DataBaseManager{
    static let shared = DataBaseManager()
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "WeatherEntity")
        container.loadPersistentStores{ _,error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
            
        }
        return container
    }()
    
    
    
    var context:NSManagedObjectContext{
        return container.viewContext
    }
    
    
    func getAllFavouries() async throws -> [FavouritesModel]{
        
        try await context.perform{
            let request:NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
            let result = try self.context.fetch(request)
            return result.map{$0.toModel()}
        }
    }
    
    func addToFavouries(place:FavouritesModel) async throws {
        try await context.perform{
            let entity = WeatherEntity(context: self.context)
            entity.id = place.id
            entity.city = place.city
            entity.country = place.country
            entity.latitude = place.latitude
            entity.longitude = place.longitude
            
            try self.context.save()
        }
    }
    
    func deleteFromFavouries(placeId:UUID) async throws {

        let request:NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", placeId as CVarArg)
        request.fetchLimit = 1
        
        if let object = try? context.fetch(request).first{
            self.context.delete(object)
            try? self.context.save()
        }
        
    }
}
