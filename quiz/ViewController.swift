//
//  ViewController.swift
//  quiz
//
//  Created by Isabelle Donsbach on 5/13/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    var settings: UIAlertController!
    
    struct Subject {
        let title: String
        let description: String
        let imageName: String
    }
    
    let data: [Subject] = [
        Subject(title: "Mathematics", description: "Are you smarter than a high schooler? Come test your mathematical memory and find out.", imageName: "math"),
        Subject(title: "Marvel Super Heroes", description: "Prove to your friends that you know the Marvel universe better than they do.", imageName: "marvel"),
        Subject(title: "Science", description: "Chemistry, Biology, and Physics. Let's see how much you remember.", imageName: "science"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        settings = UIAlertController(title: "Settings", message: "settings go here", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in print("OK")})
        settings.addAction(OKAction)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subject = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubjectTableViewCell
        cell.label.text = subject.title
        cell.descriptionLabel.text = subject.description
        cell.iconImageView.image = UIImage(named: subject.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    @IBAction func settingsClick(_ sender: Any) {
        self.present(settings, animated: true)
    }

}

