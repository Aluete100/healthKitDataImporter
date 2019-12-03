//
//  HKRecord.swift
//  HealthKitDataSeeds
//
//  Created by Alan Antar on 10/21/19.
//  Copyright © 2019 Alan Antar. All rights reserved.
//

import UIKit
import HealthKit

// struct HKRecord
class HKRecord {
    var type: String = String()
    var value: Double = 0
    var unit: String?
    var sourceName: String = String()
    var sourceVersion: String = String()
    var startDate: Date = Date()
    var endDate: Date = Date()
    var creationDate: Date = Date()
    
    //for workouts
    var activityType: HKWorkoutActivityType? = HKWorkoutActivityType(rawValue: 0)
    var totalEnergyBurned: Double = 0
    var totalEnergyBurnedUnit: String = String()
    var totalDistance: Double = 0
    var totalDistanceUnit: String = String()
    
    var metadata: [String: Any]?
    
    
    init(_ dictionary: [String: Any]) {
        let hasMeta = dictionary["metadata"] as? Array<Dictionary<String, Any>> ?? nil

        self.type = (dictionary["type"] as? String) ?? ""
        self.sourceName = (dictionary["sourceName"] as? String) ?? ""
        self.sourceVersion = (dictionary["sourceVersion"] as? String) ?? ""
       
        if hasMeta != nil {
            var metadataData = Dictionary<String, AnyObject>()
            
            for data in hasMeta!{
                let valueData = data["value"]!
                
                if valueData is Int{
                    metadataData.updateValue(valueData as AnyObject, forKey: data["key"]! as! String)
                }else{
                    metadataData.updateValue(valueData as AnyObject, forKey: data["key"]! as! String)
                }
            }
            
            self.metadata = metadataData
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        if let date = dateFormatter.date(from: (((dictionary["startDate"]! as! String)))) {
            self.startDate = date
        }else{
            self.startDate = Date()
        }
        if let date = dateFormatter.date(from: ((dictionary["endDate"]! as! String))){
            self.endDate = date
        }
        if self.startDate >  self.endDate {
            self.startDate = self.endDate
        }
        if let date = dateFormatter.date(from: ((dictionary["creationDate"]! as? String))!){
                self.creationDate = date
        }
                        
        if (self.type == "HKWorkoutTypeIdentifier"){
            self.activityType = (activityByName(activityName: (dictionary["workoutActivityType"] as? String) ?? ""))
            self.value = (dictionary["duration"] as? Double) ?? 0
            self.unit = (dictionary["durationUnit"] as? String) ?? ""
            self.totalDistance = (dictionary["totalDistance"] as? Double) ?? 0
            self.totalDistanceUnit = (dictionary["totalDistanceUnit"] as? String) ?? ""
            self.totalEnergyBurned = (dictionary["totalEnergyBurned"] as? Double) ?? 0
            self.totalEnergyBurnedUnit = (dictionary["totalEnergyBurnedUnit"] as? String) ?? ""
        }else if (self.type == "HKCategoryTypeIdentifierMenstrualFlow"){
            self.value = Double(sexualValue(sexualValue: ((dictionary["value"] as? String)!)))
        }else{
            self.value = (dictionary["value"] as? Double) ?? 0
            self.unit = dictionary["unit"] as? String ?? ""
        }
    }
    
    func activityByName(activityName: String) -> HKWorkoutActivityType {
        var res = HKWorkoutActivityType(rawValue: 0)
        
        switch activityName {
        case "HKWorkoutActivityTypeSwimming":
            res = HKWorkoutActivityType.swimming
        case "HKWorkoutActivityTypeWalking":
            res = HKWorkoutActivityType.walking
        case "HKWorkoutActivityTypeRunning":
            res = HKWorkoutActivityType.running
        case "HKWorkoutActivityTypeCycling":
            res = HKWorkoutActivityType.cycling
        case "HKWorkoutActivityTypeMixedMetabolicCardioTraining":
            //res = HKWorkoutActivityType.mixedCardio
            //res = HKWorkoutActivityType.highIntensityIntervalTraining
            res = HKWorkoutActivityType.mixedCardio
        case "HKWorkoutActivityTypeYoga":
            res = HKWorkoutActivityType.yoga
        case "HKWorkoutActivityTypeFunctionalStrengthTraining":
            res = HKWorkoutActivityType.functionalStrengthTraining
        case "HKWorkoutActivityTypeTraditionalStrengthTraining":
            res = HKWorkoutActivityType.traditionalStrengthTraining
        case "HKWorkoutActivityTypeDance":
            res = HKWorkoutActivityType.dance
        default:
            print ("???????")
            print ("Add support for activity - \(activityName)")
            break;
        }
        return res!
    }
    
    func sexualValue(sexualValue: String) -> Int{
        var sexualNumber: Int? = nil
        
        switch sexualValue {
        case "HKCategoryValueMenstrualFlowUnspecified":
            sexualNumber = HKCategoryValueMenstrualFlow.unspecified.rawValue
        case "HKCategoryValueMenstrualFlowNone":
                sexualNumber = HKCategoryValueMenstrualFlow.none.rawValue
        case "HKCategoryValueMenstrualFlowLight":
                sexualNumber = HKCategoryValueMenstrualFlow.light.rawValue
        case "HKCategoryValueMenstrualFlowMedium":
            sexualNumber = HKCategoryValueMenstrualFlow.medium.rawValue
        case "HKCategoryValueMenstrualFlowHeavy":
            sexualNumber = HKCategoryValueMenstrualFlow.heavy.rawValue
        default:
            print ("???????")
            print ("Add support for category value - \(sexualValue)")
            break;
        }
        return sexualNumber!
    }
}
