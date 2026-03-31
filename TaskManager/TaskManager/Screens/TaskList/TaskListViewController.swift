//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by Mahi on 30/3/26.
//

import UIKit
import SwiftData

class TaskListViewController: UIViewController {

    // MARK: - Properties
    private var showCompleted = false
    private var modelContext: ModelContext!
    private var tasks: [Task] = []

    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    private lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Pending", "Completed"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        return sc
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .add,
                        target: self,
                        action: #selector(addButtonTapped))
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tasks"
        navigationItem.rightBarButtonItem = addButton
        setupLayout()
        modelContext = appModelContext()
        navigationItem.titleView = segmentControl
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
         print("📂 DB Path: \(urls.first!)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks()   // refresh every time we return to this screen
    }

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func filterChanged() {
        showCompleted = segmentControl.selectedSegmentIndex == 1
        fetchTasks()
    }
    
    // MARK: - SwiftData: Fetch
    private func fetchTasks() {
        let isComplete = showCompleted   // capture for #Predicate

        let descriptor = FetchDescriptor<Task>(
            predicate: #Predicate<Task> { task in
                task.isComplete == isComplete
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        tasks = (try? modelContext.fetch(descriptor)) ?? []
        tableView.reloadData()
    }

    // MARK: - Navigation
    @objc private func addButtonTapped() {
        let vc = AddTaskViewController()
        vc.onTaskSaved = { [weak self] in
            self?.fetchTasks()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell",
                                                  for: indexPath)
        let task = tasks[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = task.title
        config.secondaryText = task.isComplete ? "Completed" : "Pending"
        cell.contentConfiguration = config

        // Checkmark for completed tasks
        cell.accessoryType = task.isComplete ? .checkmark : .disclosureIndicator

        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {

    // Tap row → go to detail
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        let vc = TaskDetailViewController(task: task, context: modelContext)
        vc.onUpdate = { [weak self] in self?.fetchTasks() }
        navigationController?.pushViewController(vc, animated: true)
    }

    // Swipe to delete
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let task = tasks[indexPath.row]
        modelContext.delete(task)
        try? modelContext.save()
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
