//
//  HKRecord.swift
//  HealthKitDataSeeds
//
//  Created by Alan Antar on 10/21/19.
//  Copyright © 2019 Alan Antar. All rights reserved.
//

import UIKit
import HealthKit

struct HKRecord {
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
    
    var metadata: [String:String]?

    init(_ dictionary: [String: Any]) {
        self.type = (dictionary["type"] as? String) ?? ""
        self.sourceName = (dictionary["sourceName"] as? String) ?? ""
        self.sourceVersion = (dictionary["sourceVersion"] as? String) ?? ""
        
        print(dictionary["sourceVersion"] as? String)
        print(dictionary["metadata"] as?  String)
        
        /*if hasMeta != "" {
            self.metadata = dictionary["metadata"] as? [String: String]
            print("Metadata")
            print(self.metadata)
        }*/
        print("No metadata")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        if let date = dateFormatter.date(from: ((dictionary["startDate"]! as! String))) {
            self.startDate = date
        }
        if let date = dateFormatter.date(from: ((dictionary["endDate"]! as? String))!){
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
        }else if (self.type == "MetadataEntry"){
            
        }else{
            self.value = (dictionary["value"] as? Double)!
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
            res = HKWorkoutActivityType.mixedMetabolicCardioTraining
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
    
}
