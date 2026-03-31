//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by Mahi on 30/3/26.
//

import UIKit
import SwiftData

class TaskDetailViewController: UIViewController {

    // MARK: - Properties
    private let task: Task
    private let modelContext: ModelContext
    var onUpdate: (() -> Void)?

    init(task: Task, context: ModelContext) {
        self.task = task
        self.modelContext = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 22, weight: .semibold)
        l.numberOfLines = 0
        return l
    }()

    private lazy var notesLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 15)
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        return l
    }()

    private lazy var statusLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14)
        l.textColor = .tertiaryLabel
        return l
    }()

    private lazy var completeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(toggleComplete), for: .touchUpInside)
        return btn
    }()

    private lazy var deleteButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Delete Task"
        config.baseBackgroundColor = .systemRed
        config.cornerStyle = .large
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Task Detail"
        setupLayout()
        populateUI()
    }

    // MARK: - Layout
    private func setupLayout() {
        [titleLabel, notesLabel, statusLabel, completeButton, deleteButton]
            .forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            notesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            notesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            notesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            statusLabel.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            completeButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 32),
            completeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 50),

            deleteButton.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 12),
            deleteButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Populate
    private func populateUI() {
        titleLabel.text = task.title
        notesLabel.text = task.notes.isEmpty ? "No notes" : task.notes
        updateStatusUI()
    }

    private func updateStatusUI() {
        statusLabel.text = "Status: \(task.isComplete ? "Completed ✓" : "Pending")"
        var config = completeButton.configuration
        config?.title = task.isComplete ? "Mark as Pending" : "Mark as Complete"
        config?.baseBackgroundColor = task.isComplete ? .systemOrange : .systemGreen
        completeButton.configuration = config
    }

    // MARK: - SwiftData: Update
    @objc private func toggleComplete() {
        task.isComplete.toggle()     // mutate the model object directly
        try? modelContext.save()     // commit to disk
        updateStatusUI()
        onUpdate?()
    }

    // MARK: - SwiftData: Delete
    @objc private func deleteTapped() {
        let alert = UIAlertController(
            title: "Delete Task",
            message: "Are you sure you want to delete \"\(task.title)\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.modelContext.delete(self.task)
            try? self.modelContext.save()
            self.onUpdate?()
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
