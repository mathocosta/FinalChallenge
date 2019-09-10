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

    // FIXME: Remover essa variável estática e fazer de outra forma
    static var healthStore = HKHealthStore()

    /// Propriedade para salvar o último instante que os dados do usuário foram atualizados.
    private var lastUpdateTime: Date {
        get {
            if let date = UserDefaults.standard.value(forKey: "LastUpdateTime") as? Date {
                return date
            } else {
                return Date()
            }
        }

        set(newUpdateTime) {
            UserDefaults.standard.set(newUpdateTime, forKey: "LastUpdateTime")
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
        from startDate: Date?, of service: HealthStoreService, completion: @escaping(ResultHandler<HKStatistics>)) {

        guard let sampleType = service.type as? HKQuantityType else { return }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

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
        let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)
        quantitySum(from: startOfDay, of: service, completion: completion)
    }

    func quantitySumSinceLastHour(
        of service: HealthStoreService, completion: @escaping(ResultHandler<HKStatistics>)) {
        let calendar = Calendar.current
        let now = Date()
        let lastHour = calendar.date(byAdding: .hour, value: -1, to: now)
        quantitySum(from: lastHour, of: service, completion: completion)
    }

    func quantitySumSinceLastUpdate(
        of service: HealthStoreService, completion: @escaping(ResultHandler<HKStatistics>)) {
        let now = Date()
        quantitySum(from: lastUpdateTime, of: service, completion: completion)
        lastUpdateTime = now
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
