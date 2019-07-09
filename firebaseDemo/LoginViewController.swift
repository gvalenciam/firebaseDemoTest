//
//  LoginViewController.swift
//  firebaseDemo
//
//  Created by Gerardo Valencia on 7/7/19.
//  Copyright © 2019 Gerardo Valencia. All rights reserved.
//
//  Clase para el log in inicial con facebook
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: BaseViewController, LoginButtonDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var firebaseLabel: UILabel!
    @IBOutlet weak var authLabel: UILabel!
    @IBOutlet weak var facebookLoginButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widgetStylesInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //Esta parte de código verifica si el usuario ya está autenticado y de ser así presenta el view controller para crear cliente. Esto es útil ya que evita que el usuario vuelva a autenticarse en caso cierre la aplicación
        
        if (AccessToken.current != nil){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let clientViewController = storyBoard.instantiateViewController(withIdentifier: "ClientViewController") as! ClientViewController
            self.present(clientViewController, animated: true, completion: nil)
        }
        
    }
    
    //Método del delegado del botón login de facebook. Aquí se empieza mostrando la vista del loader y luego verificando si ocurrió algún error en el login y de ser así muestra una alerta con la descripción del mismo (el proceso termina). De no haber error se procede a la autenticación en Firebase usando las credenciales obtenidas del login de facebook (provider), si es exitoso se presente el siguiente view controller, caso contrario, se muestra el error al usuario y termina el proceso ocultando la vista del loader.
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        self.showLoader()
        
        if let error = error {
            self.hideLoader()
            self.showDialog(title: "Error", description: error.localizedDescription, buttonText: "OK")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            self.hideLoader()
            
            if let error = error {
                self.showDialog(title: "Error", description: error.localizedDescription, buttonText: "OK")
                return
            }
            
            //User signed in Firebase
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let clientViewController = storyBoard.instantiateViewController(withIdentifier: "ClientViewController") as! ClientViewController
            self.present(clientViewController, animated: true, completion: nil)
            
        }
        
    }
    
    //Método que se ejecuta al presionar el botón de facebook cuando el usuario ya está autenticado, es decir, para hacer un log out. Se muestra la vista de loader y se espera a que termine el proceso (En teoría este método no debería ejecutarse para este VC ya que en la siguiente vista de crear cliente se tiene un botón para este propósito)
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        self.showLoader()
    }
    
    //Inicialización de componentes UI
    func widgetStylesInit(){
        
        self.backgroundImage.image = UIImage.init(named: "loginBackgroundImage")
        
        self.firebaseLabel.font = UIFont(name: "RoadRage", size: 23.0)
        self.firebaseLabel.textColor = UIColor.white
        self.firebaseLabel.text = "FIR"
        
        self.authLabel.font = UIFont(name: "RoadRage", size: 23.0)
        self.authLabel.textColor = UIColor.white
        self.authLabel.text = "AUTH"
        
        self.facebookLoginButton.delegate = self
        self.facebookLoginButton.permissions = ["public_profile", "email"]
        
    }
    
}

