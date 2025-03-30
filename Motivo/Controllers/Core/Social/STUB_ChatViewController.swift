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
        // TODO: for groupView testing
        let testLabel = BoldTitleLabel(textLabel: "Test Group View Display")

        view.addSubview(testLabel)
        
        let groupView1 = GroupView(
            image: UIImage(systemName: "person.3.fill")!,
            groupName: "Fitness 101 01",
            categories: ["Exercise", "Nutrition"],
            memberCount: 4,
            habitsCount: 3)
        view.addSubview(groupView1)
        
        let groupView2 = GroupView(
            image: UIImage(systemName: "person.3.fill")!,
            groupName: "Outdoorsmen",
            categories: ["Exercise", "Social", "Productivity", "Hobby", "Finance"],
            memberCount: 4,
            habitsCount: 3)
        view.addSubview(groupView2)
        
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        groupView1.translatesAutoresizingMaskIntoConstraints = false
        groupView2.translatesAutoresizingMaskIntoConstraints = false
        
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
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            groupView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupView1.topAnchor.constraint(equalTo: testLabel.bottomAnchor, constant: 100),
            groupView1.widthAnchor.constraint(equalToConstant: groupViewWidth),
            groupView1.heightAnchor.constraint(equalToConstant: groupViewHeight),
            groupView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupView2.topAnchor.constraint(equalTo: groupView1.bottomAnchor, constant: 20),
            groupView2.widthAnchor.constraint(equalToConstant: groupViewWidth),
            groupView2.heightAnchor.constraint(equalToConstant: groupViewHeight),
            stack.topAnchor.constraint(equalTo: groupView2.bottomAnchor, constant: 10),
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
