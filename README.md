# TaskManager

A fully functional iOS Task Manager app built with **UIKit** and **SwiftData** — developed as a learning project to master Apple's modern persistence framework without SwiftUI.

---

## Screenshots

<p align="center">
  <img width="220" src="https://github.com/user-attachments/assets/7ab56c72-c4b9-4836-ad86-dea390209eb2" />
  <img width="220" src="https://github.com/user-attachments/assets/3651d2d1-b781-45b9-a5ba-476f3d609051" />
  <img width="220" src="https://github.com/user-attachments/assets/c68cfe79-ddf1-4555-8c70-79b89638f3fc" />
  <img width="220" src="https://github.com/user-attachments/assets/3b3f2de8-1f10-45dc-90c1-d02e9993ebea" />
  <img width="220" src="https://github.com/user-attachments/assets/d7634e89-6bf9-4cf2-9c4d-1046aacd4381" />
  <img width="220" src="https://github.com/user-attachments/assets/a327cc50-b4ee-46fb-aab3-3586801b1440" />



</p>

---

## About the Project

TaskManager is a step-by-step learning project that covers every core SwiftData concept through real working code. No SwiftUI, no `.xcdatamodeld` file, no `NSManagedObject` — just plain Swift classes, UIKit, and SwiftData macros.

The app lets you create, read, update, and delete tasks, filter them by status, and sort them by date or title — all persisted to a local SQLite database via SwiftData.

---

## Features

- Create tasks with a title and optional notes
- Mark tasks as complete / pending
- Delete tasks with a confirmation alert
- Swipe to delete from the task list
- Filter tasks by **Pending** or **Completed**
- Sort tasks by **Date** or **Title**
- Persistent storage via SwiftData (SQLite)
- Empty state UI for each filter
- Input validation with shake animation

---

## SwiftData Concepts Covered

| Concept | Where Used |
|---|---|
| `@Model` | `Task.swift` |
| `@Attribute(.unique)` | `Task.id` |
| `ModelContainer` | `AppDelegate` |
| `ModelContext` | Every screen |
| `insert()` + `save()` | Add Task screen |
| `fetch()` + `FetchDescriptor` | Task List screen |
| `delete()` + `save()` | Swipe to delete + Detail screen |
| Property mutation + `save()` | Toggle complete in Detail |
| `#Predicate` | Filter Pending / Completed |
| `SortDescriptor` | Sort by date or title |

---

## Project Structure

```
TaskManager_SwiftData_UIKit/
├── App/
│   ├── AppDelegate.swift          # ModelContainer setup
│   └── SceneDelegate.swift        # Root navigation setup
├── Models/
│   └── Task.swift                 # @Model definition
├── Screens/
│   ├── TaskList/
│   │   └── TaskListViewController.swift   # Fetch, filter, sort, delete
│   ├── AddTask/
│   │   └── AddTaskViewController.swift    # Insert new task
│   └── TaskDetail/
│       └── TaskDetailViewController.swift # Update, delete
```

---

## Requirements

| Requirement | Version |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| Interface | UIKit (Programmatic — no Storyboard) |

> SwiftData requires iOS 17 or later.

---

## Getting Started

1. Clone the repository

```bash
git clone https://github.com/muhaiminmahi/TaskManager_SwiftData_UIKit.git
```

2. Open the project in Xcode

3. Select a simulator running iOS 17 or later

4. Press **Cmd+R** to build and run

No dependencies, no SPM packages, no CocoaPods — this project uses only Apple frameworks.

---

## Architecture

This project follows a simple **MVC** pattern with manual dependency passing — keeping it approachable for learning purposes.

- `AppDelegate` owns the `ModelContainer` for the app's lifetime
- Each screen creates its own `ModelContext` via the `appModelContext()` helper
- The detail screen receives the same `ModelContext` as the list screen to keep changes in sync
- Callbacks (`onTaskSaved`, `onUpdate`) are used to trigger list refreshes after changes

```
AppDelegate
└── ModelContainer (owns SQLite store)
    └── ModelContext (one per screen)
        ├── TaskListViewController  — fetch, filter, sort, delete
        ├── AddTaskViewController   — insert, save
        └── TaskDetailViewController — update, delete
```

---

## Data Model

```swift
@Model
class Task {
    @Attribute(.unique) var id: UUID
    var title: String
    var notes: String
    var isComplete: Bool
    var createdAt: Date
}
```

---

## How It Works

**Creating a task**
```swift
let task = Task(title: "Buy groceries", notes: "Milk, eggs")
modelContext.insert(task)
try? modelContext.save()
```

**Fetching with filter and sort**
```swift
let isComplete = showCompleted
let descriptor = FetchDescriptor<Task>(
    predicate: #Predicate { $0.isComplete == isComplete },
    sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
)
let tasks = try modelContext.fetch(descriptor)
```

**Updating a task**
```swift
task.isComplete.toggle()
try? modelContext.save()
```

**Deleting a task**
```swift
modelContext.delete(task)
try? modelContext.save()
```

---

## What's Next

Planned extensions to this project:

- [ ] Add `Category` model with relationships
- [ ] Search bar using `#Predicate` string matching
- [ ] iCloud sync via CloudKit
- [ ] Due date reminders with `UserNotifications`
- [ ] Unit tests with in-memory `ModelConfiguration`
- [ ] Schema migration when adding new fields

---

## Resources

- [Apple — Meet SwiftData (WWDC 2023)](https://developer.apple.com/videos/play/wwdc2023/10187/)
- [Apple — Model your schema with SwiftData (WWDC 2023)](https://developer.apple.com/videos/play/wwdc2023/10195/)
- [Apple — Migrate to SwiftData (WWDC 2023)](https://developer.apple.com/videos/play/wwdc2023/10189/)
- [Hacking with Swift — SwiftData](https://www.hackingwithswift.com/quick-start/swiftdata)

---

## License

This project is available under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Author

Made with the help of step-by-step SwiftData + UIKit learning.  
Feel free to fork, star, and build on top of it!
