//
//  CoreDataGateway.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataGateway {

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = CoreDataStore.context) {
        self.viewContext = viewContext
    }

    // MARK: - Métodos genéricos

    /// Salva um objeto no Core Data, basicamente salva o contexto.
    /// 
    /// - Parameter entity: Objeto a ser salvo
    /// - Parameter completion: Callback para ser executado quando a operação finalizar
    func save<T>(_ entity: T, completion: @escaping (ResultHandler<T>)) where T: NSManagedObject {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                completion(.success(entity))
                print("Context saved")
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Obtem um objeto no Core Data baseado no nome da entidade e no UUID dele. Como o fetch obtém uma lista
    /// de resultados, esse método retorna apenas o primeiro encontrado.
    ///
    /// - Parameter id: Identificador do objeto a ser buscado
    /// - Parameter entityName: Nome da entidade do objeto
    /// - Parameter completion: Callback para ser executado quando a operação finalizar
    func object<T>(with id: UUID, of entityName: String,
                   completion: @escaping (ResultHandler<T>)) where T: NSManagedObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let fetchResults = try viewContext.fetch(fetchRequest)
            if let result = fetchResults as? [T], let firstObject = result.first {
                completion(.success(firstObject))
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    /// Obtém os objetos de determinada instância e retorna os resultados.
    ///
    /// - Parameter entityName: Nome da entidade dos objetos
    /// - Parameter completion: Callback para ser executado quando a operação finalizar
    func objects<T>(of entityName: String, completion: @escaping (ResultHandler<[T]>)) where T: NSManagedObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            let fetchResults = try viewContext.fetch(fetchRequest)
            if let result = fetchResults as? [T] {
                completion(.success(result))
            }
        } catch let error {
            completion(.failure(error))
        }
    }
}
