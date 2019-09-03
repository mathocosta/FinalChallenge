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
    var lastUpdateTime: Date! = AppDelegate.defaults.value(forKey: "LastUpdate") as? Date {
        didSet {
            AppDelegate.defaults.setValue(self.lastUpdateTime, forKey: "LastUpdate")
        }
    }
    // FIXME: Remover essa variável estática e usar outra coisa
    static var healthStore = HKHealthStore()

    /// Solicita autorização do usuário para leitura dos dados necessários para o app.
    /// É necessário ser executado antes de buscar os dados na `HKHealthStore`.
    /// - Parameter completion: Executado ao final do método, tem como parâmentro "true" em caso de sucesso e
    /// "false" em caso de fracasso.
    func requestAuthorization(completion: @escaping ((Bool) -> Void)) {
        guard HKHealthStore.isHealthDataAvailable() else { return completion(false) }
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }

        HealthStoreManager.healthStore.requestAuthorization(
            toShare: [],
            read: [stepCountType]
        ) { (success, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }

            completion(success)
        }
    }


    /// Executa uma query na `HKHealthStore` pelos samples do tipo passado como parâmetro e retorna o
    /// resultado do somatório das quantidades desde o último intervalo capturado.
    /// - Parameter from: Data de início da consulta
    /// - Parameter sampleType: Tipo do sample a ser buscado
    /// - Parameter completion: Callback para ser executado após a consulta
    func quantitySum(from: Date?,
        of sampleType: HKQuantityType, completion: @escaping((Result<HKStatistics, Error>) -> Void)) {
        let now = Date()
        let predicate = HKQuery.predicateForSamples(
            withStart: from, end: now, options: .strictStartDate)

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

    func quantitySumSinceLastHour(
        of sampleType: HKQuantityType, completion: @escaping((Result<HKStatistics, Error>) -> Void)) {
        let calendar = Calendar.current
        let now = Date()
        let lastHour = calendar.date(byAdding: .hour, value: -1, to: now)
        quantitySum(from: lastHour, of: sampleType, completion: completion)
    }

    func quantitySumSinceLastUpdate(
        of sampleType: HKQuantityType, completion: @escaping((Result<HKStatistics, Error>) -> Void)) {
        let now = Date()
        quantitySum(from: self.lastUpdateTime, of: sampleType, completion: completion)
        self.lastUpdateTime = now
    }

}
