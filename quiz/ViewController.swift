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
    var urlErr: UIAlertController!
    
    struct Subject {
        let title: String
        let description: String
        let imageName: String
        let questions: [Question]
    }
    
    var subjects: [Subject] = []
    
    var urlInput: String!
    
    /*var subjects: [Subject] = [
        Subject(title: "Mathematics", description: "Are you smarter than a high schooler? Come test your mathematical memory and find out.", imageName: "math", questions: [Question(question: "What is 2+2", option1: "1", option2: "2", option3: "3", option4: "4", correct: 4), Question(question: "What is 448/16", option1: "4", option2: "16", option3: "24", option4: "28", correct: 4), Question(question: "How many seconds are in a day?", option1: "84,200", option2: "97,000", option3: "86,400", option4: "66,000", correct: 3)]),
        Subject(title: "Marvel Super Heroes", description: "Prove to your friends that you know the Marvel universe better than they do.", imageName: "marvel", questions: [Question(question: "How many infinity stones are there?", option1: "6", option2: "5", option3: "8", option4: "9", correct: 1), Question(question: "Who rescued Tony Stark and Nebula from space?", option1: "Rocket", option2: "Captain Marvel", option3: "Dr. Strange", option4: "Spiderman", correct: 2), Question(question: "Stan Lee made his final cameo in which Marvel movie?", option1: "Avengers: Endgame", option2: "Ant-Man and the Wasp", option3: "Spiderman Homecoming", option4: "Black Panther", correct: 1)]),
        Subject(title: "Science", description: "Chemistry, Biology, and Physics. Let's see how much you remember.", imageName: "science", questions: [Question(question: "What is the first element on the periodic table", option1: "Oxygen", option2: "Hydrogen", option3: "Carbon", option4: "Helium", correct: 2), Question(question: "Unlike most other fish, what do sharks not have?", option1: "heart", option2: "liver", option3: "gills", option4: "bones", correct: 4), Question(question: "What do you get if you mix all colours of light?", option1: "white", option2: "black", option3: "rainbow", option4: "blue", correct: 1)]),
    ]*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        uploadData(newUrl: "https://tednewardsandbox.site44.com/questions.json")
        
        settings = UIAlertController(title: "Settings", message: "Click 'OK' to cancel and click 'Check Now' to download from site", preferredStyle: .alert)
        settings.addTextField { (textField) in textField.text = "enter url"}
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {  (action) in print("OK")})
        let CheckNowAction = UIAlertAction(title: "Check Now", style: .default, handler: { (action) in self.urlInput = self.settings.textFields![0].text; self.checkDownload()})
        settings.addAction(OKAction)
        settings.addAction(CheckNowAction)
    }
    
    func uploadData(newUrl: String) {
        var newSubjects: [Subject] = []
        let url = URL(string: newUrl)
        if url != nil {
            let session = URLSession.shared.dataTask(with: url!) {
                data, response, error in
                
                if response != nil {
                    if (response! as! HTTPURLResponse).statusCode != 200 {
                        print("Something went wrong! \(String(describing: error))")
                    }
                }
                
                if response != nil {
                    _ = response! as! HTTPURLResponse
                
                    do {
                        let questions = try JSONSerialization.jsonObject(with: data!)
                        if let subjects = questions as? [[String: Any]] {
                            for subject in subjects {
                                let title = subject["title"] as? String
                                let description = subject["desc"] as? String
                                var imageName = ""
                                if title == "Mathematics" {
                                    imageName = "math"
                                } else if title == "Marvel Super Heroes" {
                                    imageName = "marvel"
                                } else if title == "Science!" {
                                    imageName = "science"
                                }
                                var questions: [Question] = []
                                let qs = subject["questions"] as? [[String: Any]]
                                for q in qs! {
                                    let question = q["text"] as! String
                                    let options = q["answers"] as! [String]
                                    let correct = Int(q["answer"] as! String)!
                                    questions.append(Question(question: question, option1: options[0], option2: options[1], option3: options[2], option4: options[3], correct: correct))
                                }
                                newSubjects.append(Subject(title: title!, description: description!, imageName: imageName, questions: questions))
                            }
                        }
                        if !newSubjects.isEmpty {
                            self.subjects = newSubjects
                            DispatchQueue.main.async {
                                self.table.reloadData()
                            }
                        }
                    }
                    catch {
                        print("Something went boom")
                    }
                }
            }
            session.resume()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subject = subjects[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubjectTableViewCell
        cell.label.text = subject.title
        cell.descriptionLabel.text = subject.description
        cell.iconImageView.image = UIImage(named: subject.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let questionVC = storyboard?.instantiateViewController(withIdentifier: "questionVC") as? QuestionViewController {
            questionVC.modalPresentationStyle = .fullScreen
            questionVC.questions = subjects[indexPath.row].questions
            self.present(questionVC, animated: true)
        }
    }
    
    @IBAction func settingsClick(_ sender: Any) {
        self.present(settings, animated: true)
    }
    
    func checkDownload() {
        uploadData(newUrl: urlInput)
    }

}

