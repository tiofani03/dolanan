//
//  FavoriteProvider.swift
//  Dolanan
//
//  Created by Tio on 01/03/23.
//

import CoreData

class FavoriteProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameEntity")
        
        container.loadPersistentStores{_, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return taskContext
    }
    
    
    func getAllFavoriteGame(completion: @escaping(_ members: [Game]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [Game] = []
                for result in results {
                    let game = Game(
                        id: result.value(forKeyPath: "id") as? Int ?? 0,
                        name: result.value(forKeyPath: "name") as? String ?? "",
                        description: result.value(forKeyPath: "gameDesc") as? String ?? "",
                        backgroundImage: result.value(forKey: "backgroundImage") as? String ?? "",
                        ratingTotal: result.value(forKeyPath: "ratingTotal") as? Double ?? 0.0,
                        ratingCount: result.value(forKeyPath: "ratingCount") as? Int ?? 0,
                        genre: result.value(forKeyPath: "genres") as? String ?? ""
                    )
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func isGameFavorite(_ id: Int, completion: @escaping(_ isFavorite: Bool) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let _ = try taskContext.fetch(fetchRequest).first {
                    completion(true)
                } else {
                    completion(false)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addToFavorite(
        _ addGame: Game,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                
                game.setValue(addGame.id, forKeyPath: "id")
                game.setValue(addGame.name, forKeyPath: "name")
                game.setValue(addGame.description, forKeyPath: "gameDesc")
                game.setValue(addGame.backgroundImage, forKeyPath: "backgroundImage")
                game.setValue(addGame.ratingTotal, forKeyPath: "ratingTotal")
                game.setValue(addGame.ratingCount, forKeyPath: "ratingCount")
                game.setValue(addGame.genre, forKeyPath: "genres")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func removeFromFavorite(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
}
