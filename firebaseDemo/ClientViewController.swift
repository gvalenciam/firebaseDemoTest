//
//  ClientViewController.swift
//  firebaseDemo
//
//  Created by Gerardo Valencia on 7/7/19.
//  Copyright © 2019 Gerardo Valencia. All rights reserved.
//
//  Clase para la creación de cliente en Firebase
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import UIKit

class ClientViewController: BaseViewController, LoginButtonDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var clientViewTitle: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var facebookLoginButton: FBLoginButton!
    @IBOutlet weak var createClientButton: UIButton!
    var databaseReference : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widgetStylesInit()
        let gestureTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(gestureTap)
        databaseReference = Database.database().reference() //Referencia al nodo principal de la base de datos de Firebase
    }
    
    //Método no usado (Cuando el usuario llega a esta vista ya está autenticado por lo que solo podría hacer log out y no volver a autenticarse)
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {}
    
    //Log out de usuario. Se muestra la vista de loader hasta que se termine de haer log out en firebase (Auth.auth().signOut()) y por último se hace dismiss de la vista actual para regresar al anterior VC
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        self.showLoader()
        try! Auth.auth().signOut()
        self.hideLoader()
        self.dismiss(animated: true, completion: nil)
    }
    
    //Método para crear cliente. Antes de rtealizar cualquier operación con Firebase se validan los campo del formulario (para hacerlo estándar se limita los campos de nombre a solo letras y el campo de edad solo a números). Si todos los campos son válidos se guarda la información en el nodo "clients" de Firebase y como primer child el ID de usuario asociado a la cuenta. Cada cliente creado tiene un ID autogenerado por Firebase pero siempre teniendo como primer child al ID de usuari de esta forma se puede llevar un mejor control de usuarios creados por cada cliente.
    
    @IBAction func createClientAction(_ sender: UIButton) {
        
        self.showLoader()
        
        if(validateClientForm()){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let databaseDict = ["name": self.nameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces),
                                "lastname": self.lastnameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces),
                                "age": self.ageTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces),
                                "birthday": dateFormatter.string(from: self.birthdayDatePicker.date)]
            
            self.databaseReference.child("clients").child(Auth.auth().currentUser!.uid).childByAutoId().setValue(databaseDict){
                
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    self.showDialog(title: "Error", description: error.localizedDescription, buttonText: "OK")
                } else {
                    self.hideLoader()
                    self.showDialog(title: "Database", description: "Data saved successfully", buttonText: "OK")
                }
                
            }
            
        }else{
            self.hideLoader()
        }
        
    }
    
    //Método usado cuando el usuario hace un tap gesture en cualquier parte del view principal lo que produce que se oculte el teclado en caso esté presente. (Opcionalmente se podría haber utilizado los métodos resigFirstResponder que haría el mismo efecto pero con algunas líneas de cóodigo más)
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Inicialización de componentes UI
    func widgetStylesInit(){
        
        self.backgroundImage.image = UIImage.init(named: "clientBackgroundImage")
        
        self.clientViewTitle.font = UIFont(name: "RoadRage", size: 23.0)
        self.clientViewTitle.textColor = self.formLabelColor
        self.clientViewTitle.text = "Create client"
        
        self.nameLabel.font = UIFont(name: "RoadRage", size: 20.0)
        self.nameLabel.textColor = self.formLabelColor
        self.nameLabel.text = "Name"
        
        self.nameTextField.font = UIFont(name: "RoadRage", size: 17.0)
        self.nameTextField.textColor = self.formTextfieldColor
        self.nameTextField.placeholder = "Name (only letters)"
        self.nameTextField.keyboardType = UIKeyboardType.namePhonePad
        self.nameTextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.nameTextField.autocapitalizationType = UITextAutocapitalizationType.words
        
        self.lastnameLabel.font = UIFont(name: "RoadRage", size: 20.0)
        self.lastnameLabel.textColor = self.formLabelColor
        self.lastnameLabel.text = "Lastname"
        
        self.lastnameTextField.font = UIFont(name: "RoadRage", size: 17.0)
        self.lastnameTextField.textColor = self.formTextfieldColor
        self.lastnameTextField.placeholder = "Last name (only letters)"
        self.lastnameTextField.keyboardType = UIKeyboardType.namePhonePad
        self.lastnameTextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.lastnameTextField.autocapitalizationType = UITextAutocapitalizationType.words
        
        self.ageLabel.font = UIFont(name: "RoadRage", size: 20.0)
        self.ageLabel.textColor = self.formLabelColor
        self.ageLabel.text = "Age"
        
        self.ageTextField.font = UIFont(name: "RoadRage", size: 17.0)
        self.ageTextField.textColor = self.formTextfieldColor
        self.ageTextField.placeholder = "Age (only numbers)"
        self.ageTextField.keyboardType = UIKeyboardType.numberPad
        self.ageTextField.keyboardAppearance = UIKeyboardAppearance.dark
        
        self.birthdayLabel.font = UIFont(name: "RoadRage", size: 20.0)
        self.birthdayLabel.textColor = self.formLabelColor
        self.birthdayLabel.text = "Birthday"
        
        self.createClientButton.backgroundColor = self.formLabelColor
        self.createClientButton.setTitle("Create client", for: UIControl.State.normal)
        self.createClientButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.createClientButton.layer.cornerRadius = 4.0
        
        self.facebookLoginButton.delegate = self
        self.facebookLoginButton.permissions = ["public_profile", "email"]
        
    }
    
    //Método para validar los campos del formulario. Aquí se aprovecha el método definido (mostrar alertas) en la clase base.
    func validateClientForm() -> Bool{
        
        if(self.nameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count  == 0){
            self.showDialog(title: "No Name", description: "Please enter name", buttonText: "OK")
            return false
        }else if(!(self.isValidName(text: self.nameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)))){
            self.showDialog(title: "Invalid Name", description: "Please enter a valid name", buttonText: "OK")
            return false
        }else if(self.lastnameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count  == 0){
            self.showDialog(title: "No Last name", description: "Please enter last name", buttonText: "OK")
            return false
        }else if(!(self.isValidName(text: self.lastnameTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)))){
            self.showDialog(title: "Invalid Last name", description: "Please enter a valid last name", buttonText: "OK")
            return false
        }else if(self.ageTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count  == 0){
            self.showDialog(title: "No Age", description: "Please enter age", buttonText: "OK")
            return false
        }else if(!(self.isValidAge(text: self.ageTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)))){
            self.showDialog(title: "Invalid Age", description: "Please enter a valid age", buttonText: "OK")
            return false
        }
        
        return true
        
    }

}
