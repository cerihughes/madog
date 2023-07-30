//
//  Created by Ceri Hughes on 25/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnySingleContainerFactory<T> = any SingleContainerFactory<T>
public protocol SingleContainerFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> MadogUIContainer<T>?
}

public typealias AnyMultiContainerFactory<T> = any MultiContainerFactory<T>
public protocol MultiContainerFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> MadogUIContainer<T>?
}

public typealias AnySplitSingleContainerFactory<T> = any SplitSingleContainerFactory<T>
public protocol SplitSingleContainerFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) -> MadogUIContainer<T>?
}

public typealias AnySplitMultiContainerFactory<T> = any SplitMultiContainerFactory<T>
public protocol SplitMultiContainerFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitMultiUITokenData<T>) -> MadogUIContainer<T>?
}
