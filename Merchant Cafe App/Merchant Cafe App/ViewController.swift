/**
 *  @author Swarn Singh.
 */

import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: AppStoryBoard.Main.rawValue, bundle:nil)
        
        var nextViewController: UIViewController
        
        if PreferenceManager.isUserLogin() {

            nextViewController = storyBoard.instantiateViewController(withIdentifier: Constants.HOME_SEGUE) as! HomeViewController
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        
        } else {

            nextViewController = storyBoard.instantiateViewController(withIdentifier: Constants.LOGIN_SEGUE) as! LoginViewController
            
            self.present(nextViewController, animated:true, completion:nil)

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

