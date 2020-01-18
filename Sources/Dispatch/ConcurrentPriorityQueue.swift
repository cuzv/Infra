import Foundation
import Dispatch

extension ConcurrentPriorityQueue {
    public typealias AsyncTask = (@escaping () -> Void) -> Void
    public typealias SyncTask = () -> Void

    public final class TaskItem: Hashable {
        let action: AsyncTask
        let id: String
        fileprivate(set) var priority: Int

        public init(id: String, priority: Int = 0, action: @escaping AsyncTask) {
            self.id = id
            self.priority = priority
            self.action = action
        }

        public convenience init(id: String, priority: Int = 0, action: @escaping SyncTask) {
            let action: AsyncTask = { done in
                action()
                done()
            }
            self.init(id: id, priority: priority, action: action)
        }

        public static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(priority)
        }
    }
}

public final class ConcurrentPriorityQueue {
    private let gatekeeperQueue: DispatchQueue
    private let concurrentQueue: DispatchQueue
    private var semaphore: Int

    private var idToTask: [String: TaskItem] = [:]
    private var priprityToTasks: [Int: OrderedSet<TaskItem>] = [:]

    public init(label: String, qos: DispatchQoS = .unspecified, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit, target: DispatchQueue? = nil, maxConcurrentCount: Int = .max) {
        gatekeeperQueue = .init(label: "Gatekeeper4\(label)")
        concurrentQueue = .init(label: label, qos: qos, attributes: [.concurrent], autoreleaseFrequency: autoreleaseFrequency, target: target)
        semaphore = maxConcurrentCount < 1 ? 1 : maxConcurrentCount > ProcessInfo.processInfo.activeProcessorCount ? ProcessInfo.processInfo.activeProcessorCount : maxConcurrentCount
    }

    public func addTask(_ task: TaskItem) {
        addTasks([task])
    }

    public func addTasks(_ tasks: [TaskItem]) {
        func execute() {
            for task in tasks {
                idToTask[task.id] = task

                var set = priprityToTasks[task.priority] ?? OrderedSet()
                set.append(task)
                priprityToTasks[task.priority] = set
            }
        }

        func dequeueTasks() -> [TaskItem] {
            guard semaphore > 0 else {
                return []
            }

            var result = [TaskItem]()

            for priority in priprityToTasks.keys.sorted(by: >) {
                if let tasks = priprityToTasks[priority], !tasks.isEmpty {
                    let remains = tasks.dropFirst(semaphore)
                    let candidates = tasks.orderedSubtracting(remains).array

                    if candidates.isEmpty {
                        priprityToTasks[priority] = nil
                    } else {
                        result.append(contentsOf: candidates)

                        priprityToTasks[priority]?.remove(candidates)
                        candidates.forEach({ idToTask[$0.id] = nil })

                        semaphore -= candidates.count
                        if 0 == semaphore {
                            break
                        }
                    }
                }
            }

            return result
        }

        func deployTasks(_ tasks: [TaskItem]) {
            guard !tasks.isEmpty else { return }

            for task in tasks {
                concurrentQueue.async {
                    autoreleasepool {
                        task.action {
                            self.gatekeeperQueue.async {
                                self.semaphore += 1
                                deployTasks(dequeueTasks())
                            }
                        }
                    }
                }
            }
        }

        gatekeeperQueue.async {
            execute()
            deployTasks(dequeueTasks())
        }
    }

    public func remove(withTaskId id: String) {
        func execute() {
            if let candidate = idToTask[id] {
                idToTask[id] = nil
                priprityToTasks[candidate.priority]?.remove(candidate)
            }
        }

        gatekeeperQueue.async {
            execute()
        }
    }

    public func removeAll() {
        func execute() {
            idToTask.removeAll()
            priprityToTasks.removeAll()
        }

        gatekeeperQueue.async {
            execute()
        }
    }

    public func alterPriority(forTaskId id: String, toPriority priority: Int) {
        func execute() {
            if let candidate = idToTask[id] {
                priprityToTasks[candidate.priority]?.remove(candidate)

                var tasks = priprityToTasks[priority] ?? OrderedSet()
                tasks.append(candidate)
                priprityToTasks[priority] = tasks
            }
        }

        gatekeeperQueue.async {
            execute()
        }
    }

    public func alterPriroity(from: Int, to: Int) {
        func execute() {
            if let candidates = priprityToTasks[from] {
                priprityToTasks[from] = nil
                candidates.forEach {
                    $0.priority = to
                }

                var tasks = priprityToTasks[to] ?? OrderedSet()
                tasks.append(contentsOf: candidates)
                priprityToTasks[to] = tasks
            }
        }

        gatekeeperQueue.async {
            execute()
        }
    }

    public func suspend() {
        concurrentQueue.suspend()
    }

    public func resume() {
        concurrentQueue.resume()
    }
}
