//
//  DetailViewController.swift
//  Project6 -APIs
//
//  Created by Vernon G Martin on 2/9/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit

extension Array{
    var last: Element {
        return self[self.endIndex - 1]
    }
}

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Displays the info pulled from the API
    @IBOutlet weak var row5ResultLabel: UILabel!
    @IBOutlet weak var row4ResultLabel: UILabel!
    @IBOutlet weak var row3ResultLabel: UILabel!
    @IBOutlet weak var row2ResultLabel: UILabel!
    @IBOutlet weak var row1ResultLabel: UILabel!
    //MARK: - Displays title of each detail field
    @IBOutlet weak var detailRow1Label: UILabel!
    @IBOutlet weak var detailRow2Label: UILabel!
    @IBOutlet weak var detailRow3Label: UILabel!
    @IBOutlet weak var detailRow4Label: UILabel!
    @IBOutlet weak var detailRow5Label: UILabel!
    //MARK: - Displays title of navigation bar and detail screen
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleNavigationBarLabel: UINavigationItem!
    //MARK: - Displays Quick Fact Bar Information
    @IBOutlet weak var largestLabel: UILabel!
    @IBOutlet weak var smallestLabel: UILabel!
    //MARK: - Buttons for unit conversion
    @IBOutlet weak var metricButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    //MARK: - Picker Wheel
    @IBOutlet weak var itemPicker: UIPickerView!
    @IBOutlet weak var exchangeRateField: UITextField!
    @IBOutlet weak var conversionButton: UIButton!
    
    var increment: Int = 0
    var titleNavigationBarText: String?
    var titleText: String?
    var detailRow1Text: String?
    var detailRow2Text: String?
    var detailRow3Text: String?
    var detailRow4Text: String?
    var detailRow5Text: String?
    var row5ResultText: String?
    var row4ResultText: String?
    var row3ResultText: String?
    var row2ResultText: String?
    var row1ResultText: String?
    var entityType: EntityOptions?
    var pickerData: [EntityDetails] = [EntityDetails]()
    var allDetailTitleTextLabels: [UILabel] = []
    var allDetailTitleText: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateResults()
        connectPickerWheelData(titleNavigationBarLabel.title!)
        
        //Loads results from first item upon page load
        pickerView(itemPicker, didSelectRow: 0, inComponent: 0)
        sortArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].attribute6
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.row1ResultLabel.text = pickerData[row].attribute1
            self.row2ResultLabel.text = pickerData[row].attribute2
            self.row3ResultLabel.text = String(pickerData[row].attribute3!)
            self.row4ResultLabel.text = pickerData[row].attribute4
            self.row5ResultLabel.text = pickerData[row].attribute5
            self.titleLabel.text = pickerData[row].attribute6

    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        allCharacters.removeAll()
        allVehicles.removeAll()
        allStarships.removeAll()
    }
    
    // Diplays the row title for each item depending on entity type
    func setDetailView(selectedView: EntityOptions){
        self.detailRow1Text = selectedView.attribute1
        self.detailRow2Text = selectedView.attribute2
        self.detailRow3Text = selectedView.attribute3
        self.detailRow4Text = selectedView.attribute4
        self.detailRow5Text = selectedView.attribute5
    }
    
    //Populates each detailw with the results form the API
    func populateResults(){
        self.itemPicker.delegate = self
        self.itemPicker.dataSource = self
        self.titleLabel.text = titleText
        
        self.titleNavigationBarLabel.title = titleNavigationBarText
        
        self.row1ResultLabel.text = row1ResultText
        self.row2ResultLabel.text = row2ResultText
        self.row3ResultLabel.text = row3ResultText
        self.row4ResultLabel.text = row4ResultText
        self.row5ResultLabel.text = row5ResultText
        
        allDetailTitleTextLabels = [detailRow1Label,detailRow2Label,detailRow3Label,detailRow4Label,detailRow5Label]
        allDetailTitleText = [detailRow1Text, detailRow2Text, detailRow3Text, detailRow4Text, detailRow5Text]
        
        for labels in allDetailTitleTextLabels{
            labels.text = allDetailTitleText[increment]
            increment += 1
        }
    }
    
    //Loads picker wheel with correct data based on entity
    func connectPickerWheelData(selectedView: String){
        print(selectedView)
        switch selectedView {
        case "Characters":
            entityType = .Characters
            print(entityType)
            pickerData = allCharacters
        case "Vehicles":
            entityType = .Vehicles
            pickerData = allVehicles
        case "Starships":
            entityType = .Starships
            pickerData = allStarships
        default: "error"
            print("error")
        }
    }
    @IBAction func convertPressed(sender: AnyObject) {
        if (row2ResultLabel.text != "unknown" && entityType != EntityOptions.Characters){
        exchangeRateField.text = String(format: "%.2f",(Double(row2ResultLabel.text!)! * Double(exchangeRateField.text!)!))
        displayMessage("Conversion Complete")
        conversionButton.enabled = false
        }
        else if entityType == EntityOptions.Characters {
            displayMessage("Cannot perform conversion. Characters have no cost")
        }
        else {
            displayMessage("There is no cost associated with this vehicle or starship")
        }
    }
    
    @IBAction func metricPressed(sender: AnyObject) {
        if Double((row3ResultLabel.text)!) != nil {
            row3ResultLabel.text = String("\(inchesToCentimetersConversion(Double(row3ResultLabel.text!)!))")
        }else {
            print("ERROR")
        }
        metricButton.enabled = false
        englishButton.enabled = true
    }
    @IBAction func englishPressed(sender: AnyObject) {
        if Double((row3ResultLabel.text)!) != nil {
            row3ResultLabel.text = String(format: "%.2f", centimetersToInches(Double(row3ResultLabel.text!)!))
        }else {
            print("ERROR")
        }
        metricButton.enabled = true
        englishButton.enabled = false
    }
    
    func displayMessage(message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sortArray(){
        print("ENTITY \(entityType)")
        print(pickerData[0].attribute6)
        pickerData = findSmallest(entityType!)
        smallestLabel.text = pickerData[0].attribute6
        largestLabel.text = pickerData.last.attribute6
    }
    
    func inchesToCentimetersConversion(inches: Double) -> Double{
        let result = (inches * 2.54)
        return result
        
    }
    
    func centimetersToInches(centimeters: Double) -> Double{
        var result = (centimeters / 2.54)
        return result
    }

}
