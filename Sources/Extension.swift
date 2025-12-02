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
