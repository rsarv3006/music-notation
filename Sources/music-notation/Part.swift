//
//	Part.swift
//	music-notation
//
//	Created by Steven Woolgar on 2021-01-30.
//	Copyright © 2021 Steven Woolgar. All rights reserved.
//

/// Placeholder for eventual staff layout description of a page footer.
public struct Part {
	// MARK: - Collection Conformance

	public typealias Index = Int
	public var startIndex: Int								{ staves.startIndex }
	public var endIndex: Int								{ staves.endIndex }
	public subscript(position: Index) -> Iterator.Element	{ staves[position] }
	public func index(after index: Int) -> Int				{ staves.index(after: index) }
	public func index(before index: Int) -> Int 			{ staves.index(before: index) }
	public typealias Iterator = IndexingIterator<[Staff]>
	public func makeIterator() -> Iterator 					{ staves.makeIterator() }

	// MARK: - Main Properties

    public var name: String
    public var shortName: String

    public var staves: [Staff] = []

	public init(
		name: String = "",
		shortName: String = "",
		staves: [Staff]
	) {
		self.staves = staves
        self.name = name
        self.shortName = shortName
	}
    
    public mutating func replaceStaff(with staff: Staff, at index: Int) {
        self.staves.replaceSubrange(index...index, with: [staff])
    }
}

extension Part: CustomDebugStringConvertible {
	public var debugDescription: String {
		let stavesDescription = staves.map { $0.debugDescription }.joined(separator: ", ")

		return "staves(\(stavesDescription))"
	}
}

