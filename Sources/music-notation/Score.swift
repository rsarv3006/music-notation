//
//	Score.swift
//	music-notation
//
//	Created by Steven Woolgar on 2021-01-30.
//	Copyright © 2021 Steven Woolgar. All rights reserved.
//

import Foundation

/// A `score` can contain 0 or more parts. Each part can have a name, color, and position within the score.
/// A `score` will also be the container for stylesheets, as well as overall data for the entire score.
public class Score: RandomAccessCollection {
	// MARK: - Collection Conformance

    public typealias Index = Int
    public var startIndex: Int								{ parts.startIndex }
    public var endIndex: Int								{ parts.endIndex }
    public subscript(position: Index) -> Iterator.Element	{ parts[position] }
    public func index(after index: Int) -> Int				{ parts.index(after: index) }
    public func index(before index: Int) -> Int 			{ parts.index(before: index) }
	public typealias Iterator = IndexingIterator<[Part]>
	public func makeIterator() -> Iterator 					{ parts.makeIterator() }

	// MARK: - Main Properties

    @Published internal private(set) var parts: [Part] = []
	@Published public var title: String = ""
    @Published public var subTitle: String = ""
    @Published public var artist: String = ""
    @Published public var album: String = ""
    @Published public var words: String = ""
    @Published public var music: String = ""
    @Published public var wordsAndMusic: String = ""
    @Published public var transcriber: String = ""
    @Published public var instructions: String = ""
    @Published public var notices: String = ""

    @Published public var firstPageHeader: PageHeader?
    @Published public var pageHeader: PageHeader?
    @Published public var pageFooter: PageFooter?

	public init(parts: [Part]) {
		self.parts = parts
	}
}

extension Score: CustomDebugStringConvertible {
	public var debugDescription: String {
		let partsDescription = parts.map { $0.debugDescription }.joined(separator: ", ")

		return "parts(\(partsDescription))"
	}
}

extension Score: ObservableObject {}
