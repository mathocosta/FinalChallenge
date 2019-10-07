//
//  HKStoreManager.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

final class HealthStoreManager {

    typealias ResultHandler<T> = (Result<T, Error>) -> Void
    typealias ResultHandlerWithDate<T> = (Result<T, Error>, Date) -> Void

    // FIXME: Remover essa variável estática e fazer de outra forma
    static var healthStore = HKHealthStore()

    /// Propriedade para salvar o último instante que os dados do usuário foram atualizados.
    private var lastUpdateTime: Date {
        get {
            return UserDefaults.standard.healthKitUpdateTime ?? Date()
        }

        set {
            UserDefaults.standard.healthKitUpdateTime = newValue
        }
    }

    /// Solicita autorização do usuário para leitura dos dados necessários para o app.
    /// É necessário ser executado antes de buscar os dados na `HKHealthStore`.
    ///
    /// - Parameter completion: Executado ao final do método, tem como parâmentro "true" em caso de sucesso e
    /// "false" em caso de fracasso.
    func requestAuthorization(completion: @escaping(ResultHandler<Bool>)) {
        let readTypes = HealthStoreService.allTypes

        HealthStoreManager.healthStore.requestAuthorization(toShare: [], read: readTypes) { (success, error) in
            if let error = error {
                completion(.failure(error))
            }

            completion(.success(success))
        }
    }

    /// Executa uma query na `HKHealthStore` pelos samples do tipo passado como parâmetro e retorna o
    /// resultado do somatório das quantidades desde o intervalo de início até o momento atual.
    ///
    /// - Parameters:
    ///   - startDate: Data do início da consulta
    ///   - service: Case do `HealthStoreService` para configurar a query
    ///   - completion: Callback para ser executado após a consulta
    func quantitySum(
        from startDate: Date?, to endDate: Date = Date(), of service: HealthStoreService, completion: @escaping(ResultHandler<HKStatistics>)) {

        guard let sampleType = service.type as? HKQuantityType else { return }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        // Constrói uma HKStatisticsQuery que busca os samples do tipo definido no `quantityType`,
        // filtra baseado no predicate e executa a operação definida nas `options`
        let statisticsQuery = HKStatisticsQuery(
            quantityType: sampleType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { (_, result, error) in
            guard let result = result, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }

            completion(.success(result))
        }

        // Executa a query na store
        HealthStoreManager.healthStore.execute(statisticsQuery)
    }

    func quantitySumToday(
        of service: HealthStoreService, completion: @escaping(ResultHandler<HKStatistics>)) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.date(bySettingHour: 3, minute: 0, second: 0, of: now)
        quantitySum(from: startOfDay, of: service, completion: completion)
    }

    func quantitySumSinceLastHour(
        of service: HealthStoreService, completion: @escaping(ResultHandler<HKStatistics>)) {
        let calendar = Calendar.current
        let now = Date()
        let lastHour = calendar.date(byAdding: .hour, value: -1, to: now)
        quantitySum(from: lastHour, of: service, completion: completion)
    }

    func quantitySumThisWeekPerDay(of service: HealthStoreService, completion: @escaping(([HKStatistics])->Void)) {
        let calendar = Calendar.current
        let now = Date()
        let interval = DateComponents(
            calendar: .current, timeZone: .current,
            era: 0, year: 0, month: 0, day: 1,
            hour: 0, minute: 0, second: 0, nanosecond: 0,
            weekday: 0, weekdayOrdinal: 0, quarter: 0, weekOfMonth: 0,
            weekOfYear: 0, yearForWeekOfYear: 0
        )

        guard let lastSunday = calendar.getLastUpdateTime(from: now),
            var startOfDay = calendar.date(bySettingHour: 3, minute: 0, second: 0, of: lastSunday),
            let sampleType = service.type as? HKQuantityType else { return }

        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: lastSunday, intervalComponents: interval)

        query.initialResultsHandler = {
            query, results, error in

            guard let statsCollection = results else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            completion(statsCollection.statistics())
        }

        HealthStoreManager.healthStore.execute(query)

//        while startOfDay.compare(now) == .orderedAscending {
//            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }
//            quantitySum(from: startOfDay, to: nextDay, of: service, completion: completion)
//            startOfDay = nextDay
//        }
    }

    func quantitySumSinceLastSunday(
        of service: HealthStoreService, completion: @escaping(ResultHandler<HKStatistics>)) {
        let calendar = Calendar.current
        let now = Date()
        let lastSunday = calendar.getLastUpdateTime(from: now)
        quantitySum(from: lastSunday, of: service, completion: completion)
    }

    /// Executa uma query para obter os samples de um determinado tipo passado como parâmetro.
    ///
    /// - Parameters:
    ///   - service: Case do `HealthStoreService` para configurar a query
    ///   - completion: Callback para ser executado após a consulta
    func samples(of service: HealthStoreService, completion: @escaping(ResultHandler<[HKSample]>)) {
        guard let sampleType = service.type as? HKSampleType else { return }

        let sampleQuery = HKSampleQuery(
            sampleType: sampleType,
            predicate: service.queryPredicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { (_, samples, error) in
            guard let actualSamples = samples, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }

            completion(.success(actualSamples))
        }

        // Executa a query na store
        HealthStoreManager.healthStore.execute(sampleQuery)
    }

}
