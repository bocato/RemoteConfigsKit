import Foundation

protocol SecretPresentationLogic {
    func presentConfigs(response: Secret.Fetch.Response)
    func presentEditAlert(response: Secret.Alert.Success.Response)
    func presentEditErrorAlert(response: Secret.Alert.Error.Response)
    func presentConfig(response: Secret.Update.Success.Response)
    func presentUpdateErrorAlert(response: Secret.Update.Error.Response)
}

final class SecretPresenter: SecretPresentationLogic {
    weak var view: SecretDisplayLogic?

    func presentConfigs(response: Secret.Fetch.Response) {
        let sections = response.configs.map(Secret.Section.init)
        let response = Secret.Fetch.ViewModel(sections: sections)
        view?.displayConfigs(viewModel: response)
    }

    func presentEditAlert(response: Secret.Alert.Success.Response) {
        let viewModel = Secret.Alert.Success.ViewModel(
            title: response.config.name,
            message: "Edit config value",
            saveOptionTitle: "Save",
            cancelOptionTitle: "Cancel",
            currentValue: response.config.currentValue
        )
        view?.displayEditAlert(viewModel: viewModel)
    }

    func presentEditErrorAlert(response: Secret.Alert.Error.Response) {
        let viewModel = Secret.Alert.Error.ViewModel(
            title: "Ops",
            message: "Couldn't load config",
            okOptionTitle: "Ok"
        )
        view?.displayEditErrorAlert(viewModel: viewModel)
    }

    func presentConfig(response: Secret.Update.Success.Response) {
        let viewModel = Secret.Update.Success.ViewModel(
            section: .init(config: response.config),
            atIndex: response.atIndex
        )

        view?.displayConfig(viewModel: viewModel)
    }

    func presentUpdateErrorAlert(response: Secret.Update.Error.Response) {
        let viewModel = Secret.Update.Error.ViewModel(
            title: "Ops",
            message: "Couldn't edit config",
            okOptionTitle: "Ok"
        )
        view?.displayUpdateErrorAlert(viewModel: viewModel)
    }
}

private extension Secret.Section {
    init(config: Secret.Configuration) {
        header = config.name
        rows = [
            .init(
                title: "Original Value",
                detail: config.originalValue,
                isSelectionEnabled: false
            ),
            .init(
                title: "Current Value",
                detail: config.currentValue,
                isSelectionEnabled: true
            ),
        ]
    }
}
