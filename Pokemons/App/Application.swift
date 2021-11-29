import UIKit

class Application {
    static let shared = Application()
    
    func start(in window: UIWindow) {
        let navigationViewController = UINavigationController()

        let pokemonProvider = PokemonProvider(httpService: HTTPService())
        let pokemonNavigator = PokemonNavigator(navigationController: navigationViewController, pokemonProvider: pokemonProvider)
        pokemonNavigator.toPokemonList()

        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}
