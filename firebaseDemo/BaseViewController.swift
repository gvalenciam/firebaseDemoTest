//
//  BaseViewController.swift
//  firebaseDemo
//
//  Created by Gerardo Valencia on 7/7/19.
//  Copyright © 2019 Gerardo Valencia. All rights reserved.
//
//  Clase modelo de la cual heredarán el resto de view controllers para reutilizar métodos y UI
//

import Foundation
import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    //Definición de variables
    
    @IBOutlet weak var loader: NVActivityIndicatorView! //Loader que servirá para indicar al usuario que se está realizando alguna acción que requiere espera (Referencia: https://cocoapods.org/pods/NVActivityIndicatorView)
    @IBOutlet weak var overlay: UIView! //UIView que se mostrará al mismo tiempo que el loader para generar un efecto de procesamiento
    let formLabelColor = UIColor.init(red: 147.0/255.0, green: 31.0/255.0, blue: 29.0/255.0, alpha: 1.0) //Color de las etiquetas del formulario de crear cliente
    let formTextfieldColor = UIColor.init(red: 105.0/255.0, green: 116.0/255.0, blue: 124.0/255.0, alpha: 1.0) //Color de texto de los campos de texto
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.type = NVActivityIndicatorType.ballScaleRippleMultiple //Tipo de loader a usar (Se pueden ver más tipos en el link de referencia)
        self.overlay.isHidden = true //Se inicializa la vista del loader como oculta
    }
    
    //Método que presenta una ventana emergente de tipo alerta para informar al usuario algún resultado o error. Se eligió definir en la clase base ya que posteriormente se podría incluir un login con usuario y contraseña en la primera vista y se podría aprovechar este método para validar campos y errores de Firebase
    
    func showDialog(title: String?, description: String?, buttonText: String?){
        
        let dialogModal = UIAlertController.init(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        let confirmAction = UIAlertAction.init(title: buttonText, style: .default, handler: nil)
        dialogModal.addAction(confirmAction)
        DispatchQueue.main.async {
            self.present(dialogModal, animated: true, completion: nil)
        }
        
    }
    
    //Método para validar el nombre ingresado para crear cliente. Se usa un regex (regular expression) para verificar el texto
    func isValidName(text: String) -> Bool{
        let regex = try! NSRegularExpression(pattern: "^[\\p{L} .'-]+$", options: [.caseInsensitive])
        return (regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) != nil)
    }
    
    //Método para validar la edad ingresada para crear cliente. Se usa un regex (regular expression) para verificar el texto
    func isValidAge(text: String) -> Bool{
        let regex = try! NSRegularExpression(pattern: "^[0-9]*$", options: [.caseInsensitive])
        return (regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) != nil)
    }
    
    //Método que muestra la vista del loader (overlay) y al mismo tiempo inicia la animación y reestringe la interacción de usuario
    func showLoader(){
        self.loader.startAnimating()
        self.overlay.isHidden = false
        self.view.isUserInteractionEnabled = false
    }
    
    //Método que oculta la vista del loader (overlay) y al mismo tiempo detiene la animación y reestablece la interacción de usuario
    func hideLoader(){
        self.loader.stopAnimating()
        self.overlay.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
    
}
