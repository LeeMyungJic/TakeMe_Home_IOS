//
//  SettingsViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    static var range = 500;
    @IBOutlet var rangeStr: UITextField!
    let rangeArray = [500, 1000, 1500, 2000]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        dismissPickerView()

        rangeStr.attributedPlaceholder = NSAttributedString(string: "범위를 설정하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rangeArray.count

    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return "\(rangeArray[row])"
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        rangeStr.text = "\(rangeArray[row])"
        SettingsViewController.range = rangeArray[row]
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        rangeStr.inputView = pickerView
    }
    
    func dismissPickerView() {
           let toolBar = UIToolbar()
            toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: nil )
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
            rangeStr.inputAccessoryView = toolBar
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }

}
