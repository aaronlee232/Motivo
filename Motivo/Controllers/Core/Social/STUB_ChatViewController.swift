//
//  ChatViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

let dummyTaskList1: [DummyTask] = [
    DummyTask(name: "Wash dishes", taskStatus: .complete),
    DummyTask(name: "Cook dinner", taskStatus: .complete),
    DummyTask(name: "Run a mile", taskStatus: .pending),
    DummyTask(name: "Do homework", taskStatus: .incomplete),
    DummyTask(name: "Charge phone", taskStatus: .incomplete)
]


let dummyTaskList2: [DummyTask] = [
    DummyTask(name: "Wash dishes", taskStatus: .complete),
    DummyTask(name: "Cook dinner", taskStatus: .complete)
]

class ChatViewController: UIViewController {

    let progressOverviewBob = TaskProgressOverviewView(name: "Bob", profileImage: nil)
    let progressOverviewJane = TaskProgressOverviewView(name: "Jane", profileImage: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        let stack = UIStackView()
        stack.axis = .vertical
        view.addSubview(stack)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        progressOverviewBob.taskList = dummyTaskList1
        progressOverviewJane.taskList = dummyTaskList2
        stack.addArrangedSubview(progressOverviewBob)
        stack.addArrangedSubview(progressOverviewJane)
        
        stack.addArrangedSubview(spacer)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
