//
//  Measure.swift
//  MusicNotation
//
//  Created by Kyle Sherman on 6/12/15.
//  Copyright (c) 2015 Kyle Sherman. All rights reserved.
//

public struct Measure: ImmutableMeasure {
	
	public let timeSignature: TimeSignature
	public let key: Key
	public private(set) var notes: [NoteCollection]
	
	public init(timeSignature: TimeSignature, key: Key) {
		self.init(timeSignature: timeSignature, key: key, notes: [])
	}
	
	public init(timeSignature: TimeSignature, key: Key, notes: [NoteCollection]) {
		self.timeSignature = timeSignature
		self.key = key
		self.notes = notes
	}
	
	public mutating func addNote(note: Note) {
		notes.append(note)
	}
	
	public mutating func insertNote(note: Note, atIndex index: Int) throws {
		// TODO: Implement
	}
	
	public mutating func removeNoteAtIndex(index: Int) throws {
		// TODO: Implement
	}
	
	public mutating func removeNotesInRange(indexRange: Range<Int>) throws {
		// TODO: Implement
	}
	
	public mutating func addTuplet(tuplet: Tuplet) {
		notes.append(tuplet)
	}
	
	public mutating func insertTuplet(tuplet: Tuplet, atIndex index: Int) throws {
		// TODO: Implement
	}
	
	public mutating func removeTuplet(tuplet: Tuplet, atIndex index: Int) throws {
		// TODO: Implement
	}
	
	public mutating func startTieAtIndex(index: Int) throws {
		try modifyTieAtIndex(index, remove: false)
	}
	
	public mutating func removeTieAtIndex(index: Int) throws {
		try modifyTieAtIndex(index, remove: true)
	}
	
	private mutating func modifyTieAtIndex(index: Int, remove: Bool) throws {
		let (firstNoteIndex, firstTupletIndex) = try noteCollectionIndexFromNoteIndex(index)
		guard let (secondNoteIndex, secondTupletIndex) =
			try? noteCollectionIndexFromNoteIndex(index + 1) else {
				throw remove ? MeasureError.NoNextNote : MeasureError.NoNextNoteToTie
		}
		var firstNote: Note
		var secondNote: Note
		let modificationMethod = remove ? Note.removeTie : Note.modifyTie
		switch (firstTupletIndex, secondTupletIndex) {
		case (nil, nil):
			firstNote = notes[firstNoteIndex] as! Note
			secondNote = notes[secondNoteIndex] as! Note
			try modificationMethod(&firstNote)(.Begin)
			try modificationMethod(&secondNote)(.End)
			notes[firstNoteIndex] = firstNote
			notes[secondNoteIndex] = secondNote
		case let (nil, secondTupletIndex?):
			firstNote = notes[firstNoteIndex] as! Note
			var tuplet = notes[secondNoteIndex] as! Tuplet
			secondNote = tuplet.notes[secondTupletIndex]
			try modificationMethod(&firstNote)(.Begin)
			try modificationMethod(&secondNote)(.End)
			notes[firstNoteIndex] = firstNote
			try tuplet.replaceNoteAtIndex(secondTupletIndex, withNote: secondNote)
			notes[secondNoteIndex] = tuplet
		case let (firstTupletIndex?, nil):
			var tuplet = notes[firstNoteIndex] as! Tuplet
			firstNote = tuplet.notes[firstTupletIndex]
			secondNote = notes[secondNoteIndex] as! Note
			try modificationMethod(&firstNote)(.Begin)
			try tuplet.replaceNoteAtIndex(firstTupletIndex, withNote: firstNote)
			try modificationMethod(&secondNote)(.End)
			notes[firstNoteIndex] = tuplet
			notes[secondNoteIndex] = secondNote
		case let (firstTupletIndex?, secondTupletIndex?):
			if firstNoteIndex == secondNoteIndex {
				var tuplet = notes[firstNoteIndex] as! Tuplet
				firstNote = tuplet.notes[firstTupletIndex]
				secondNote = tuplet.notes[secondTupletIndex]
				try modificationMethod(&firstNote)(.Begin)
				try modificationMethod(&secondNote)(.End)
				try tuplet.replaceNoteAtIndex(firstTupletIndex, withNote: firstNote)
				try tuplet.replaceNoteAtIndex(secondTupletIndex, withNote: secondNote)
				notes[firstNoteIndex] = tuplet
			} else {
				var firstTuplet = notes[firstNoteIndex] as! Tuplet
				firstNote = firstTuplet.notes[firstTupletIndex]
				var secondTuplet = notes[secondNoteIndex] as! Tuplet
				secondNote = secondTuplet.notes[secondTupletIndex]
				try modificationMethod(&firstNote)(.Begin)
				try modificationMethod(&secondNote)(.End)
				try firstTuplet.replaceNoteAtIndex(firstTupletIndex, withNote: firstNote)
				try secondTuplet.replaceNoteAtIndex(secondTupletIndex, withNote: secondNote)
				notes[firstNoteIndex] = firstTuplet
				notes[secondNoteIndex] = secondTuplet
			}
		}
	}
	
	internal func noteCollectionIndexFromNoteIndex(index: Int) throws -> (noteIndex: Int, tupletIndex: Int?) {
		// Gets the index of the given element in the notes array by translating the index of the
		// single note within the NoteCollection array.
		guard index >= 0 && notes.count > 0 else { throw MeasureError.NoteIndexOutOfRange }
		// Expand notes and tuplets into indexes
		// TODO: Move this into a method that is called on didSet of notes??
		var noteIndexes: [(Int, Int?)] = []
		for (i, noteCollection) in notes.enumerate() {
			switch noteCollection.noteCount {
			case 1:
				noteIndexes.append((noteIndex: i, tupletIndex: nil))
			case let count:
				for j in 0..<count {
					noteIndexes.append((noteIndex: i, tupletIndex: j))
				}
			}
		}
		guard index < noteIndexes.count else { throw MeasureError.NoteIndexOutOfRange }
		return noteIndexes[index]
	}
}

extension Measure: Equatable {}

public func ==(lhs: Measure, rhs: Measure) -> Bool {
	guard lhs.timeSignature == rhs.timeSignature &&
		lhs.key == rhs.key &&
		lhs.notes.count == rhs.notes.count else {
			return false
	}
	for i in 0..<lhs.notes.count {
		if lhs.notes[i] == rhs.notes[i] {
			continue
		} else {
			return false
		}
	}
	return true
}

// Debug extensions
extension Measure: CustomDebugStringConvertible {
	public var debugDescription: String {
		let notesString = notes.map { "\($0)" }.joinWithSeparator(",")
		return "|\(timeSignature): \(notesString)|"
	}
}

public enum MeasureError: ErrorType {
	case NoNextNoteToTie
	case NoTieBeginsAtIndex
	case NoteIndexOutOfRange
	case NoNextNote
}
