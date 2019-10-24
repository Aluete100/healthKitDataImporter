//
//  ViewController.swift
//  HealthKitDataSeeds
//
//  Created by Alan Antar on 10/21/19.
//  Copyright © 2019 Alan Antar. All rights reserved.
//

import UIKit
import HealthKit


let healthStore: HKHealthStore = HKHealthStore()

class ViewController: UIViewController {

    var allHKRecords: [HKRecord] = []
    var allHKSampels: [HKSample] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func startSeedingData(_ sender: Any) {
        self.authorizeHealthKit()
    }
    
    func authorizeHealthKit(){
        let shareReadObjectTypes:Set<HKSampleType> = [
            HKQuantityType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount)!,
            HKQuantityType.quantityType(forIdentifier:HKQuantityTypeIdentifier.flightsClimbed)!,
            // Body Measurements
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyFatPercentage)!,
            // Nutrient
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatSaturated)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!,
            // Fitness
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
            HKWorkoutType.workoutType(),
            // Category
            HKQuantityType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
            
            //Heart rate
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate)!,

            // Measurements
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyFatPercentage)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.leanBodyMass)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
            // Nutrients
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatPolyunsaturated)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatMonounsaturated)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatSaturated)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCholesterol)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySodium)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminA)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminB6)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminB12)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminC)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminD)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminE)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminK)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCalcium)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryIron)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryThiamin)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryRiboflavin)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryNiacin)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFolate)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryBiotin)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryPantothenicAcid)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryPhosphorus)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryIodine)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryMagnesium)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryZinc)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySelenium)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCopper)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryManganese)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryChromium)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryMolybdenum)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryChloride)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryPotassium)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.uvExposure)!,
            // Fitness
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!,
            // Results
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.respiratoryRate)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalBodyTemperature)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodAlcoholContent)!]

        if !HKHealthStore.isHealthDataAvailable(){
            print("Error ocurred")
            return
        }
        
        healthStore.requestAuthorization(toShare: shareReadObjectTypes, read: shareReadObjectTypes, completion: {(success, error) -> Void in
            if let error = error {
                print(error)
            } else {
                print("Read Write Authorization succeeded")
                self.readJSONFromFile()
            }
        })
    }
    
    
    func readJSONFromFile()
    {
        if let path = Bundle.main.path(forResource: "export", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonDataArray = json as? [[String: Any]] else {return}
                
                for record in jsonDataArray{
                    self.allHKRecords.append(HKRecord(record))
                    self.saveHKRecord(item: HKRecord(record), withSuccess: {
                        // success
                        print("record added to array")
                    }, failure: {
                        // fail
                        print("fail to process record")
                    })
                }
            } catch {
                print("Error reading file")
            }
        }
    }
    
    
    @IBAction func seedQuantityData(_ sender: Any) {
        
    }
    
    @IBAction func saveValues(_ sender: Any) {
        saveAllSamples()
    }
    
        
    func saveHKRecord(item:HKRecord, withSuccess successBlock: @escaping () -> Void, failure failiureBlock: @escaping () -> Void) {
      
        let unit = HKUnit.init(from: item.unit ?? "")
        let quantity = HKQuantity(unit: unit, doubleValue: item.value)
        
        var hkSample: HKSample? = nil
        if let type = HKQuantityType.quantityType(forIdentifier:  HKQuantityTypeIdentifier(rawValue: item.type)) {
            hkSample = HKQuantitySample.init(type: type, quantity: quantity, start: item.startDate, end: item.endDate)
        }else if item.type == HKObjectType.workoutType().identifier {
            hkSample = HKWorkout.init(activityType: item.activityType ?? HKWorkoutActivityType(rawValue: 0)!, start: item.startDate, end: item.endDate, duration: item.value, totalEnergyBurned: HKQuantity(unit: HKUnit.init(from: item.totalEnergyBurnedUnit), doubleValue: item.totalEnergyBurned), totalDistance: HKQuantity(unit: HKUnit.init(from: item.totalDistanceUnit), doubleValue: item.totalDistance), device: nil, metadata: item.metadata)
        } else {
            print("didnt catch this item - \(item)")
        }
        
        if let hkSample = hkSample, (healthStore.authorizationStatus(for: hkSample.sampleType) == HKAuthorizationStatus.sharingAuthorized) {
            allHKSampels.append(hkSample)
            successBlock()
        } else {
            failiureBlock()
        }
    }
    
    func saveAllSamples() {
        saveSamplesToHK(samples: self.allHKSampels, withSuccess: {
            print("Samples updated successfully")
        }, failure: {
             print("Error updating samples")
        })
    }
    
    func saveSamplesToHK (samples:[HKSample], withSuccess successBlock: @escaping () -> Void, failure failiureBlock: @escaping () -> Void) {
        healthStore.save(samples, withCompletion: { (success, error) in
            if (!success) {
                print(String(format: "An error occured saving the sample. The error was: %@.", error.debugDescription))
                failiureBlock()
            }
            DispatchQueue.main.async {
                print(samples.count)
            }
            successBlock()
        })
    }
    
    func writeDataToHealthKit(){
        /*createRandomRecords()
        healthStore.save(allHKSampels, withCompletion: {(success, error) in
                       print("Saved \(success), error \(error)")
                   })*/
        
        /*let weight = Double(self.txtWeight.text!)
        let today = NSDate()
    
        if let type = HKSampleType.quantityType(forIdentifier: .bodyMass){
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(weight!))
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            
            healthStore.save(sample, withCompletion: {(success, error) in
                print("Saved \(success), error \(error)")
            })
            
        }*/
    }
}

