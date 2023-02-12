//
//	TimeSignature.swift
//	MusicNotation
//
//	Created by Kyle Sherman on 2015-06-12.
//	Copyright © 2015 Kyle Sherman. All rights reserved.
//

public class TimeSignature {
	public var topNumber: Int
    public var bottomNumber: Int
    public var tempo: Int

	public init(topNumber: Int, bottomNumber: Int, tempo: Int) {
		// TODO: Check the validity of all these values
		self.topNumber = topNumber
		self.bottomNumber = bottomNumber
		self.tempo = tempo
	}
}

extension TimeSignature: CustomDebugStringConvertible {
	public var debugDescription: String {
		"\(topNumber)/\(bottomNumber)"
	}
}

extension TimeSignature: Equatable {
	public static func == (lhs: TimeSignature, rhs: TimeSignature) -> Bool {
		if lhs.topNumber == rhs.topNumber,
			lhs.bottomNumber == rhs.bottomNumber,
			lhs.tempo == rhs.tempo {
			return true
		} else {
			return false
		}
	}
}
