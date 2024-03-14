//
//  SavedMovie+CoreDataProperties.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 14.3.24..
//
//

import Foundation
import CoreData


extension SavedMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMovie> {
        return NSFetchRequest<SavedMovie>(entityName: "SavedMovie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var adult: Bool
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int64

}

extension SavedMovie : Identifiable {

}
