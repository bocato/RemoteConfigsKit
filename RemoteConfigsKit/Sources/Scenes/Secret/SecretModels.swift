import Foundation

enum Secret {
    // MARK: Use Cases

    enum Fetch {
        struct Request {
            let searchText: String
        }

        struct Response {
            let configs: [Configuration]
        }

        struct ViewModel {
            let sections: [Section]
        }
    }

    enum Alert {
        struct Request {
            let atIndex: Int
        }

        enum Success {
            struct Response {
                let config: Configuration
            }

            struct ViewModel {
                let title: String
                let message: String
                let saveOptionTitle: String
                let cancelOptionTitle: String
                let currentValue: String
            }
        }

        enum Error {
            struct Response {}

            struct ViewModel {
                let title: String
                let message: String
                let okOptionTitle: String
            }
        }
    }

    enum Update {
        struct Request {
            let newValue: String
        }

        enum Success {
            struct Response {
                let config: Configuration
                let atIndex: Int
            }

            struct ViewModel {
                let section: Section
                let atIndex: Int
            }
        }

        enum Error {
            struct Response {}

            struct ViewModel {
                let title: String
                let message: String
                let okOptionTitle: String
            }
        }
    }

    // MARK: Models

    struct Configuration {
        let name: String
        let originalValue: String
        let currentValue: String
    }

    struct Row {
        let title: String
        let detail: String
        let isSelectionEnabled: Bool
    }

    struct Section {
        let header: String
        let rows: [Row]
    }
}
