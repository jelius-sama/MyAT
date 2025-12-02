#if canImport(Glibc)
    import Glibc
#elseif canImport(Musl)
    import Musl
#endif

/*
 * HTTP Parser for parsing raw HTTP requests.
 */
public final class HTTPParser {

    public init() {}

    /*
     * Find the index of "\r\n\r\n" in the buffer.
     * Returns the range of the header end marker.
     */
    public func findHeaderEnd(
        in buffer: Array<UInt8>
    ) -> Optional<Range<Int>> {
        if buffer.count < 4 {
            return Optional<Range<Int>>.none
        }

        let pattern = Array<UInt8>(Array("\r\n\r\n".utf8))
        let maxIndex = buffer.count - pattern.count

        var i = 0
        while i <= maxIndex {
            var matched = true
            var j = 0
            while j < pattern.count {
                if buffer[i + j] != pattern[j] {
                    matched = false
                    break
                }
                j += 1
            }
            if matched {
                let range = i..<(i + pattern.count)
                return Optional<Range<Int>>.some(range)
            }
            i += 1
        }

        return Optional<Range<Int>>.none
    }

    /*
     * Parse HTTP/1.1 request from raw string.
     * Extracts request line (method, path, version) and headers.
     * Body parsing is not yet implemented.
     */
    public func parseRequest(from raw: String) -> HTTPRequest {
        let lines = raw.split(
            separator: "\r\n",
            omittingEmptySubsequences: false
        )
        var method = "GET"
        var path = "/"
        var version = "HTTP/1.1"

        if lines.count > 0 {
            let requestLineParts = lines[0].split(separator: " ")
            if requestLineParts.count >= 3 {
                method = String(requestLineParts[0])
                path = String(requestLineParts[1])
                version = String(requestLineParts[2])
            }
        }

        var headers = HTTPHeaders()
        if lines.count > 1 {
            var index = 1
            while index < lines.count {
                let line = lines[index]
                index += 1
                if line.isEmpty {
                    break
                }

                if let separatorIndex = line.firstIndex(of: ":") {
                    let name = String(line[..<separatorIndex])
                        .trimmingCharacters(in: .whitespaces)
                    let valueStart = line.index(after: separatorIndex)
                    let value = String(line[valueStart...])
                        .trimmingCharacters(in: .whitespaces)
                    headers[name] = value
                }
            }
        }

        let body = Array<UInt8>()
        return HTTPRequest(
            method: method,
            path: path,
            version: version,
            headers: headers,
            body: body
        )
    }
}
