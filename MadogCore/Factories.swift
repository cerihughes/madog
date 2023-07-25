//
//  Created by Ceri Hughes on 25/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnySingleContainerFactory<T> = any SingleContainerFactory<T>
public protocol SingleContainerFactory<T> {
    associatedtype T
    func createContainer<VC, C>(
        registry: AnyRegistry<T>,
        tokenData: SingleUITokenData<VC, C, T>
    ) -> MadogModalUIContainer<T>?
}

public typealias AnyMultiContainerFactory<T> = any MultiContainerFactory<T>
public protocol MultiContainerFactory<T> {
    associatedtype T
    func createContainer<VC, C>(
        registry: AnyRegistry<T>,
        tokenData: MultiUITokenData<VC, C, T>
    ) -> MadogModalUIContainer<T>?
}

public typealias AnySplitSingleContainerFactory<T> = any SplitSingleContainerFactory<T>
public protocol SplitSingleContainerFactory<T> {
    associatedtype T
    func createContainer<VC, C>(
        registry: AnyRegistry<T>,
        tokenData: SplitSingleUITokenData<VC, C, T>
    ) -> MadogModalUIContainer<T>?
}

public typealias AnySplitMultiContainerFactory<T> = any SplitMultiContainerFactory<T>
public protocol SplitMultiContainerFactory<T> {
    associatedtype T
    func createContainer<VC, C>(
        registry: AnyRegistry<T>,
        tokenData: SplitMultiUITokenData<VC, C, T>
    ) -> MadogModalUIContainer<T>?
}
