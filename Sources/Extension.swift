/*
 * Small helper to trim whitespace on Swift.String without pulling in
 * extra utilities.
 */
private extension String {
    func trimmingCharacters(
        in characterSet: CharacterSet
    ) -> String {
        var start = startIndex
        var end = index(before: endIndex)

        while start <= end
            && characterSet.contains(
                unicodeScalars[start].value
            )
        {
            start = index(after: start)
        }

        while end >= start
            && characterSet.contains(
                unicodeScalars[end].value
            )
        {
            end = index(before: end)
        }

        if start > end {
            return ""
        }

        return String(self[start...end])
    }
}

extension String {
    var jsSafe: String {
        // Trims whitespace and newlines, then replaces multiple semicolons with a single one.
        return
            self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: ";\n")  // Keeps line breaks and adds semicolons
            .replacingOccurrences(of: ";{2,}", with: ";", options: .regularExpression)  // Removes extra semicolons
            .replacingOccurrences(of: ";\\s*\\n", with: "\n", options: .regularExpression)  // Removes semicolon followed by newline
            + "\n"  // Ensure the string ends with a newline
    }
}

/*
 * Very small CharacterSet stand-in for whitespace trimming.
 */
private struct CharacterSet {
    private let scalars: Set<UInt32>

    static let whitespaces: CharacterSet = {
        let list: Array<UInt32> = Array<UInt32>(
            arrayLiteral: 9, 10, 11, 12, 13, 32
        )
        return CharacterSet(scalars: Set(list))
    }()

    init(scalars: Set<UInt32>) {
        self.scalars = scalars
    }

    func contains(_ value: UInt32) -> Bool {
        return scalars.contains(value)
    }
}
