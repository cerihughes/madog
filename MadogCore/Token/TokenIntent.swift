//
//  Created by Ceri Hughes on 25/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public enum TokenIntent<T> {
    case useParent(T)
}

extension TokenIntent {
    var token: T {
        switch self {
        case let .useParent(token):
            return token
        }
    }
}
