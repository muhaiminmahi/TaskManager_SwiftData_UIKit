//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by Mahi on 30/3/26.
//

import UIKit
import SwiftData

class AddTaskViewController: UIViewController {

    // Callback so TaskList knows to refresh
    var onTaskSaved: (() -> Void)?

    private var modelContext: ModelContext!

    // MARK: - UI
    private lazy var titleField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Task title"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        return tf
    }()

    private lazy var notesView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 15)
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.text = "Notes (optional)"
        tv.textColor = .placeholderText
        return tv
    }()

    private lazy var saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Save Task"
        config.cornerStyle = .large
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Task"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self, action: #selector(cancelTapped))

        modelContext = appModelContext()
        setupLayout()
        notesView.delegate = self
    }

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(titleField)
        view.addSubview(notesView)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 44),

            notesView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16),
            notesView.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            notesView.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            notesView.heightAnchor.constraint(equalToConstant: 120),

            saveButton.topAnchor.constraint(equalTo: notesView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions
    @objc private func saveTapped() {
        guard let title = titleField.text, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            shakeField()
            return
        }

        let notes = notesView.textColor == .placeholderText ? "" : notesView.text ?? ""

        // SwiftData: create and insert
        let newTask = Task(title: title, notes: notes)
        modelContext.insert(newTask)

        do {
            try modelContext.save()
            onTaskSaved?()
            dismiss(animated: true)
        } catch {
            print("Save failed: \(error)")
        }
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    private func shakeField() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.values = [-8, 8, -6, 6, -4, 4, 0]
        animation.duration = 0.4
        titleField.layer.add(animation, forKey: "shake")
    }
}

// MARK: - UITextViewDelegate (placeholder behaviour)
extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes (optional)"
            textView.textColor = .placeholderText
        }
    }
}
