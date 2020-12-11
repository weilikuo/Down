//
//  Down-Example
//
//  Created by Weili Kuo on 12/10/20.
//  Copyright © 2020 Down. All rights reserved.
//

import UIKit
import Down

class DownLabel: UILabel {

    init(markDown: String) {
        super.init(frame: .zero)
        let down = Down(markdownString: markDown)
        attributedText = try? down.toAttributedString()
    }

    required init?(coder: NSCoder) {
        fatalError("use init(markDown:)")
    }
}
