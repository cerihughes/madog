@_exported import MadogCore
@_exported import MadogContainers_iOS

public extension Madog {
    static func withDefaultContainers() -> Self {
        let madog: Self = .init()
        madog.registerDefaultContainers()
        return madog
    }
}
