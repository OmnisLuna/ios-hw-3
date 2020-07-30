import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    let animation = Animations()
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown(notification:)),
            name: UIResponder.keyboardWillShowNotification,
                object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
                object: nil)
    }

    @IBAction func loginPressed(_sender: UIButton, forEvent event: UIEvent) {
        
                Auth.auth().signIn(withEmail: loginField.text!, password: passwordField.text!) {
                    (result, error) in
                    if let error = error {
//                        print("ERROR! - \(error.localizedDescription)")
                        let alert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "ок", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Успешный вход!")
                        
                        //записываем авторизованного пользователя в firestore
                        let id = Auth.auth().currentUser?.uid
                        let email = Auth.auth().currentUser?.email
                        self.ref = self.db.collection("users").addDocument(data: [
                            "id": id,
                            "email": email,
                        ])
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }
                }
                
//                Auth.auth().createUser(withEmail: loginField.text ?? "", password: passwordField.text ?? "") {
//                    (result, error) in
//                        if let error = error {
//                            print("ERROR! - \(error.localizedDescription)")
//                        } else {
//                            print(result?.user.email)
//                        }
//                }

    }

    @objc func keyboardWasShown(notification: Notification) {
      let userInfo = (notification as NSNotification).userInfo as! [String: Any]
      let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect

      scrollBottomConstraint.constant = frame.height
    }

    @objc func keyboardWillBeHidden(notification: Notification) {
      scrollBottomConstraint.constant = 0
    }

//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        // Проверяем данные
//        let checkResult = checkUserData()
//
//        // Если данные не верны, покажем ошибку
//        if !checkResult {
//            showLoginError()
//        }
//
//        // Вернем результат
//        return checkResult
//    }

//    func checkUserData() -> Bool {
//        guard let login = loginField.text,
//            let password = passwordField.text else { return false }
//
//        if login == "admin" && password == "1234" {
//            return true
//        } else {
//            return false
//        }
//    }

    func showLoginError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка", message: "Введены неверные данные пользователя", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }

}
