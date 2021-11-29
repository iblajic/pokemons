import UIKit

protocol PokemonNavigatorType {
    func toPokemonList()
    func toPokemonDetails(title: String,url: String)
}

class PokemonNavigator: PokemonNavigatorType {
    private let navigationController: UINavigationController
    private let pokemonProvider: PokemonProviderType

    init(navigationController: UINavigationController, pokemonProvider: PokemonProviderType) {
        self.navigationController = navigationController
        self.pokemonProvider = pokemonProvider
    }

    func toPokemonList() {
        let viewModel = PokemonListViewModel(provider: pokemonProvider, navigator: self)
        let viewController = PokemonListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }

    func toPokemonDetails(title: String, url: String) {
        let viewModel = PokemonDetailsViewModel(provider: pokemonProvider, url: url)
        let viewController = PokemonDetailsViewController(title: title, viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
