//
//  AddPetViewController.swift
//  PetApi
//
//  Created by Haya Alqahtani on 04/03/2024.
//
//
import UIKit
import Alamofire
import SnapKit
import Eureka
class AddPetViewController: FormViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        submitTapped()
    }
    
    
    private func setupForm() {
        form +++ Section("Add New pet")
        <<< TextRow() { row in
            row.title = "Pet Name"
            row.placeholder = "Enter Pet Name"
            row.tag = "name"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChange
            row.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
        }
        
       
        <<< IntRow() { row in
            row.title = "Pet Age"
            row.placeholder = "Enter Pet Age"
            row.tag = "Age"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChange
            row.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
        }
        
        <<< TextRow() { row in
            row.title = "Gender"
            row.placeholder = "Enter Pet Gender "
            row.tag = "Gender"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChange
            row.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                    
                }
            }
        }
        <<< SwitchRow() { row in
            row.title = "Adopted"
            row.tag = "adopted"
         }
        <<< URLRow() { row in
            row.title = "Pet Image"
            row.placeholder = "Enter Pet Image"
            row.tag = "Image"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChange
            row.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
        }
        form +++ Section("")
        
        
        <<< ButtonRow(){ row in
            row.title = "Add Pet"
            row.onCellSelection{  cell, row in
                print("Button")
                self.submitTapped()
            }
        }
        
    }
    
    @objc func submitTapped() {
        let errors = form.validate()
        guard errors.isEmpty else {
            presentAlertWithTitle(title: "Error", message: "Please fill out all fields.")
            return
        }
        
        let nameRow: TextRow? = form.rowBy(tag: "PetName")
        let GenderRow: TextRow? = form.rowBy(tag: "Gender")
        let AgeRow: DecimalRow? = form.rowBy(tag: "PetAge")
        let imageRow: URLRow? = form.rowBy(tag: "ImageURL")
        let adoptedRow : SwitchRow? = form.rowBy(tag: "Adopted")
        
        let name = nameRow?.value ?? ""
        let age = AgeRow?.value ?? 0
        let imageUrl = imageRow?.value?.absoluteString ?? ""
        let Gender = GenderRow?.value ?? ""
        let adopted = adoptedRow?.value ?? false
        
        let pet = Pet(id: nil , name: name, adopted: adopted , image: imageUrl, age: Int(age), gender: Gender)
        
        print(pet)
        
        
        NetworkManager.shared.addPet(pet: pet) { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    print("error")
                }
            }
        }
        
        
        
    }
        
        
    private func presentAlertWithTitle(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
