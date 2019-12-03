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

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var allHKRecords: [HKRecord] = []
    var allHKSampels: [HKSample] = []
    
    @IBOutlet weak var fileSelectorSwitch: UISwitch!
    @IBOutlet weak var numberOfSamplesLabel: UILabel!
    @IBOutlet weak var typesTableView: UITableView!
    @IBOutlet weak var urlTextField: UITextField!
    
    let sharedMemory: SharedMemory = SharedMemory.global
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwitch()
        setupTextField()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupTextField(){
        urlTextField.delegate = self
    }
    
    func setupTableView(){
        typesTableView.dataSource = self
        typesTableView.delegate = self
    }
    
    func setupSwitch(){
        fileSelectorSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchChanged(mSwitch: UISwitch) {
        removeData()
        self.urlTextField.isHidden = !mSwitch.isOn
    }
    
    @IBAction func startSeedingData(_ sender: Any) {
        removeData()
        self.authorizeHealthKit()
    }
        
    func authorizeHealthKit(){
        let shareReadObjectTypes:Set<HKSampleType> = [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!,
            // Body Measurements
            HKQuantityType.quantityType(forIdentifier:  .height)!,
            HKQuantityType.quantityType(forIdentifier:  .bodyMass)!,
            HKQuantityType.quantityType(forIdentifier:  .bodyFatPercentage)!,
            HKQuantityType.quantityType(forIdentifier:  .waistCircumference)!,
            // Nutrient
            HKQuantityType.quantityType(forIdentifier:  .dietaryProtein)!,
            HKQuantityType.quantityType(forIdentifier:  .dietaryFatTotal)!,
            HKQuantityType.quantityType(forIdentifier:  .dietaryFatSaturated)!,
            HKQuantityType.quantityType(forIdentifier:  .dietaryCarbohydrates)!,
            HKQuantityType.quantityType(forIdentifier:  .dietarySugar)!,
            HKQuantityType.quantityType(forIdentifier:  .dietaryEnergyConsumed)!,
            HKQuantityType.quantityType(forIdentifier:  .bloodGlucose)!,
            // Fitness
            HKQuantityType.quantityType(forIdentifier:  .activeEnergyBurned)!,
            HKWorkoutType.workoutType(),
            
            //Heart rate
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!,

            // Measurements
            HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)!,
            HKQuantityType.quantityType(forIdentifier: .height)!,
            HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
            HKQuantityType.quantityType(forIdentifier: .leanBodyMass)!,
            HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!,
            // Nutrients
            HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryFatMonounsaturated)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryFatSaturated)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryCholesterol)!,
            HKQuantityType.quantityType(forIdentifier: .dietarySodium)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryFiber)!,
            HKQuantityType.quantityType(forIdentifier: .dietarySugar)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryProtein)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryVitaminA)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryVitaminB6)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryVitaminB12)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryVitaminC)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryVitaminD)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryVitaminE)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryVitaminK)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryCalcium)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryIron)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryThiamin)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryRiboflavin)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryNiacin)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryFolate)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryBiotin)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryPantothenicAcid)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryPhosphorus)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryIodine)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryMagnesium)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryZinc)!,
            HKQuantityType.quantityType(forIdentifier: .dietarySelenium)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryCopper)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryManganese)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryChromium)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryMolybdenum)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryChloride)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryPotassium)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryWater)!,
            HKQuantityType.quantityType(forIdentifier: .uvExposure)!,
            // Fitness
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .pushCount)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWheelchair)!,
            HKQuantityType.quantityType(forIdentifier: .swimmingStrokeCount)!,
            HKQuantityType.quantityType(forIdentifier: .distanceDownhillSnowSports)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!,
            // Results
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!,
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
            HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
            HKQuantityType.quantityType(forIdentifier: .insulinDelivery)!,
            HKQuantityType.quantityType(forIdentifier: .numberOfTimesFallen)!,
            HKQuantityType.quantityType(forIdentifier: .peripheralPerfusionIndex)!,
            HKQuantityType.quantityType(forIdentifier: .forcedVitalCapacity)!,
            HKQuantityType.quantityType(forIdentifier: .forcedExpiratoryVolume1)!,
            HKQuantityType.quantityType(forIdentifier: .peakExpiratoryFlowRate)!,
            HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!,
            HKQuantityType.quantityType(forIdentifier: .basalBodyTemperature)!,
            HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!,
            HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKQuantityType.quantityType(forIdentifier: .bloodAlcoholContent)!,
            HKQuantityType.quantityType(forIdentifier: .electrodermalActivity)!,
            HKQuantityType.quantityType(forIdentifier: .inhalerUsage)!,
            
            //Audio
            HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure)!,
            HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure)!,


            // Category
            HKCategoryType.categoryType(forIdentifier: .cervicalMucusQuality)!,
            HKCategoryType.categoryType(forIdentifier: .intermenstrualBleeding)!,
            HKCategoryType.categoryType(forIdentifier: .ovulationTestResult)!,
            HKCategoryType.categoryType(forIdentifier: .sexualActivity)!,
            HKCategoryType.categoryType(forIdentifier: .toothbrushingEvent)!,
            HKCategoryType.categoryType(forIdentifier: .mindfulSession)!,
            HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKCategoryType.categoryType(forIdentifier: .menstrualFlow)!]
        
            // Sample Type
            //HKSampleType.audiogramSampleType()
        
            /* Not allowed writing permissions */
        
            //HKQuantityType.quantityType(forIdentifier: .nikeFuel)!,
            //HKCategoryType.categoryType(forIdentifier: .lowHeartRateEvent)!,
            //HKCategoryType.categoryType(forIdentifier: .highHeartRateEvent)!,
            //HKCategoryType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!,
            //HKCategoryType.categoryType(forIdentifier: .appleStandHour)!,
            //HKCategoryType.categoryType(forIdentifier: .audioExposureEvent)!,

        if !HKHealthStore.isHealthDataAvailable(){
            print("Error ocurred")
            return
        }
               
        healthStore.requestAuthorization(toShare: shareReadObjectTypes, read: shareReadObjectTypes, completion: {(success, error) -> Void in
            if let error = error {
                print(error)
            } else {
                print("Read Write Authorization succeeded, starting to seed data")
                self.selectDataSource()
            }
        })
    }
    
    func selectDataSource(){
        DispatchQueue.main.async {
            if self.fileSelectorSwitch.isOn {
                if (self.sharedMemory.hkDataUrl != nil && self.sharedMemory.hkDataUrl != ""){
                    self.readJsonFromURL(url: self.sharedMemory.hkDataUrl!)
                }else{
                    print("Please add an URL to fetch the data :D")
                }
            }else{
                self.readJSONFromFile()
            }
        }
    }
    
    func removeData(){
        self.numberOfSamplesLabel.text = "0"
        self.allHKSampels.removeAll()
        self.typesTableView.reloadData()
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
                    self.saveHKRecord(item: HKRecord(record), withSuccess: {
                        // success
                        print("record added to array")
                    }, failure: {
                        // fail
                        print("fail to process record")
                        print(record)
                    })
                }
                self.saveAllDataSamples()
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    func readJsonFromURL(url: String){
        self.loadingDialog()

        guard let url = URL(string: url) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data, error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                
                guard let jsonDataArray = json as? [[String: Any]] else {return}
                
                for record in jsonDataArray{
                    self.saveHKRecord(item: HKRecord(record), withSuccess: {
                        // success
                        print("record added to array")
                    }, failure: {
                        // fail
                        print("fail to process record")
                        print(record)
                    })
                }
                self.saveAllDataSamples()
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
        dismiss(animated: false, completion: nil)
    }
            
    func saveHKRecord(item:HKRecord, withSuccess successBlock: @escaping () -> Void, failure failiureBlock: @escaping () -> Void) {
      
        let unit = HKUnit.init(from: item.unit ?? "")
        let quantity = HKQuantity(unit: unit, doubleValue: item.value)
                
        var hkSample: HKSample? = nil
        if let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: item.type)) {
            hkSample = HKQuantitySample.init(type: type, quantity: quantity, start: item.startDate, end: item.endDate, metadata: item.metadata)
        }else if let type = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: item.type)){
            hkSample = HKCategorySample.init(type: type, value: Int(item.value), start: item.startDate, end: item.endDate, metadata: item.metadata)
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
    
    func saveAllDataSamples() {
        saveSamplesToHK(samples: self.allHKSampels, withSuccess: {
            print("Samples updated successfully")
            DispatchQueue.main.async {
                self.showSuccessMessage()
                self.numberOfSamplesLabel.text = String(self.allHKSampels.count)
            }
        }, failure: {
             print("Error updating samples")
        })
    }
      
    func saveSamplesToHK(samples:[HKSample], withSuccess successBlock: @escaping () -> Void, failure failiureBlock: @escaping () -> Void) {
        healthStore.save(samples, withCompletion: { (success, error) in
            if (!success) {
                print(String(format: "An error occured saving the sample. The error was: %@.", error.debugDescription))
                failiureBlock()
            }
            DispatchQueue.main.async {
                self.typesTableView.reloadData()
                print(samples.count)
            }
            successBlock()
        })
    }
    
    private func loadingDialog(){
        let alert = UIAlertController(title: nil, message: "Give me a sec...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessMessage(){
            let alert = UIAlertController(title: "Heyy Youu!!!", message: "All the data has been saved succesfully!! 😎", preferredStyle: UIAlertController.Style.alert)

            let ok = UIAlertAction(title: "Niiiiceeee", style: .default, handler: { action in
            })
            alert.addAction(ok)

            self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sharedMemory.hkDataUrl = self.urlTextField.text
        self.urlTextField.isHidden = true
        self.urlTextField.resignFirstResponder()
        self.readJsonFromURL(url: self.sharedMemory.hkDataUrl!)
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if allHKSampels.count > 0 {
            return 1
        }else{
            self.emptyMessage(message: "Theres no data to show yet")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allHKSampels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = typesTableView.dequeueReusableCell(withIdentifier: "HKTypeCell", for: indexPath)
        if  indexPath.row < allHKSampels.count{
            cell.textLabel!.text = "\(allHKSampels[indexPath.row].sampleType)"
        }
        return cell
    }
    
    func emptyMessage(message:String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.typesTableView.backgroundView = messageLabel;
        self.typesTableView.separatorStyle = .none;
    }
}

