//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

/// Used to uniquely identify a view controller in the app.
struct SampleToken {
    let identifier: String
    let data: [String: Any]
}

extension SampleToken {
    static let stringDataKey = "stringData"

    var stringData: String? {
        data[SampleToken.stringDataKey] as? String
    }
}
