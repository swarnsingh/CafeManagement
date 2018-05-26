/**
 *  @author Swarn Singh.
 */

import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PreferenceManager.isUserLogin() {
            self.performSegue(withIdentifier: Constants.HOME_SEGUE, sender: nil)
        } else {
            self.performSegue(withIdentifier: Constants.LOGIN_SEGUE, sender: nil)
        }
    }
    
    private func showAlert(message:String?) {
        let alert = UIAlertController(title: "Alert?", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

