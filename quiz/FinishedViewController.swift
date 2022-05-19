//
//  FinishedViewController.swift
//  quiz
//
//  Created by Isabelle Donsbach on 5/19/22.
//

import UIKit

class FinishedViewController: UIViewController {
    
    @IBOutlet weak var descriptive: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score = 0
    var max = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "\(score)/\(max)"
        let ratio = Double(score)/Double(max)
        if ratio == 1.0 {
            descriptive.text = "Perfect!"
        } else if ratio >= 0.75 {
            descriptive.text = "Almost!"
        } else if ratio >= 0.5 {
            descriptive.text = "Okay!"
        } else if ratio >= 0.25 {
            descriptive.text = "Not great"
        } else {
            descriptive.text = "Not even close :("
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonClick() {
        if let subjectVC = storyboard?.instantiateViewController(withIdentifier: "subjectVC") as? ViewController {
            subjectVC.modalPresentationStyle = .fullScreen
            self.present(subjectVC, animated: true)
        }
    }
    
    @IBAction func nextButtonClick() {
        if let subjectVC = storyboard?.instantiateViewController(withIdentifier: "subjectVC") as? ViewController {
            subjectVC.modalPresentationStyle = .fullScreen
            self.present(subjectVC, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
