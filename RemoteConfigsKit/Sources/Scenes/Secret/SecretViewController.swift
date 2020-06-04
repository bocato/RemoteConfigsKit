import Foundation
import UIKit

protocol SecretDisplayLogic: AnyObject {
    func displayConfigs(viewModel: Secret.Fetch.ViewModel)
    func displayConfig(viewModel: Secret.Update.Success.ViewModel)
    func displayUpdateErrorAlert(viewModel: Secret.Update.Error.ViewModel)
    func displayEditAlert(viewModel: Secret.Alert.Success.ViewModel)
    func displayEditErrorAlert(viewModel: Secret.Alert.Error.ViewModel)
}

final class SecretViewController: UITableViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()

    private let interactor: SecretBusinessLogic
    private var currentSections: [Secret.Section] = []
    private var alertBeingPresented: UIAlertController?

    init(interactor: SecretBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { nil }

    override func loadView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = searchBar
        view = tableView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        interactor.fetchConfigs(request: .init(searchText: ""))
    }

    // MARK: - Private Methods

    private func showErrorAlert(viewModel: ErrorViewModel) {
        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: viewModel.okOptionTitle,
                style: .default,
                handler: nil
            )
        )

        present(alert, animated: true, completion: nil)
    }

    private func showEditAlert(viewModel: Secret.Alert.Success.ViewModel) {
        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert
        )

        alert.addAction(
            .init(
                title: viewModel.saveOptionTitle,
                style: .default,
                handler: saveOptionHandler
            )
        )

        alert.addAction(
            .init(
                title: viewModel.cancelOptionTitle,
                style: .cancel,
                handler: nil
            )
        )

        alert.addTextField { textField in
            textField.text = viewModel.currentValue
        }

        present(alert, animated: true, completion: nil)

        alertBeingPresented = alert
    }

    private func saveOptionHandler(action: UIAlertAction) {
        guard let alert = alertBeingPresented else { return }
        guard let textField = alert.textFields?.first else { return }
        guard let newValue = textField.text, !newValue.isEmpty else { return }
        interactor.updateValue(request: .init(newValue: newValue))
    }
}

// MARK: - UITableViewDataSource

extension SecretViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        currentSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentSections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let row = currentSections[indexPath.section].rows[indexPath.row]

        cell.selectionStyle = row.isSelectionEnabled ? .default : .none
        cell.accessoryType = row.isSelectionEnabled ? .disclosureIndicator : .none
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.detail

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        currentSections[section].header
    }
}

// MARK: - UITableViewDelegate

extension SecretViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = Secret.Alert.Request(atIndex: indexPath.section)
        interactor.fetchEditAlert(request: request)
    }
}

// MARK: - SecretDisplayLogic

extension SecretViewController: SecretDisplayLogic {
    func displayConfigs(viewModel: Secret.Fetch.ViewModel) {
        currentSections = viewModel.sections
        tableView.reloadData()
    }

    func displayConfig(viewModel: Secret.Update.Success.ViewModel) {
        if currentSections.indices ~= viewModel.atIndex {
            currentSections[viewModel.atIndex] = viewModel.section
            tableView.reloadData()
        }
    }

    func displayUpdateErrorAlert(viewModel: Secret.Update.Error.ViewModel) {
        showErrorAlert(viewModel: .init(viewModel: viewModel))
    }

    func displayEditAlert(viewModel: Secret.Alert.Success.ViewModel) {
        showEditAlert(viewModel: viewModel)
    }

    func displayEditErrorAlert(viewModel: Secret.Alert.Error.ViewModel) {
        showErrorAlert(viewModel: .init(viewModel: viewModel))
    }
}

private struct ErrorViewModel {
    let title: String
    let message: String
    let okOptionTitle: String

    init(viewModel: Secret.Update.Error.ViewModel) {
        title = viewModel.title
        message = viewModel.message
        okOptionTitle = viewModel.okOptionTitle
    }

    init(viewModel: Secret.Alert.Error.ViewModel) {
        title = viewModel.title
        message = viewModel.message
        okOptionTitle = viewModel.okOptionTitle
    }
}

extension SecretViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor.fetchConfigs(request: .init(searchText: searchText))
    }
}
