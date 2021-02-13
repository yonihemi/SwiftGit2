import Foundation
import Clibgit2

public enum SwiftGit2Error: Error, CustomStringConvertible, Equatable {
	/// Generic error
	case genericError(libgit2Error: Libgit2Error)

	/// Requested object could not be found
	case objectNotFound(libgit2Error: Libgit2Error)

	/// Object exists preventing operation
	case objectAlreadyExists(libgit2Error: Libgit2Error)

	/// More than one object matches
	case multipleObjectsExist(libgit2Error: Libgit2Error)

	/// Output buffer too short to hold data
	case outputBufferTooShort(libgit2Error: Libgit2Error)

	/// a special error that is never generated by libgit2
	/// code.  You can return it from a callback (e.g to stop an iteration)
	/// to know that it was generated by the callback and not by libgit2.
	case userContext(libgit2Error: Libgit2Error)

	/// Operation not allowed on bare repository
	case bareRepo(libgit2Error: Libgit2Error)

	/// HEAD refers to branch with no commits
	case headWithoutCommits(libgit2Error: Libgit2Error)

	/// Merge in progress prevented operation
	case mergeInProgress(libgit2Error: Libgit2Error)

	/// Reference was not fast-forwardable
	case referenceNotFastForwardable(libgit2Error: Libgit2Error)

	/// Name/ref spec was not in a valid format
	case invalidSpec(libgit2Error: Libgit2Error)

	/// Checkout conflicts prevented operation
	case checkoutConflicts(libgit2Error: Libgit2Error)

	/// Lock file prevented operation
	case fileLocked(libgit2Error: Libgit2Error)

	/// Reference value does not match expected
	case unexpectedReferenceValue(libgit2Error: Libgit2Error)

	/// Authentication error
	case authenticationError(libgit2Error: Libgit2Error)

	/// Server certificate is invalid
	case invalidServerCertificate(libgit2Error: Libgit2Error)

	/// Patch/merge has already been applied
	case alreadyApplied(libgit2Error: Libgit2Error)

	/// The requested peel operation is not possible
	case peelNotPossible(libgit2Error: Libgit2Error)

	/// Unexpected EOF
	case endOfFile(libgit2Error: Libgit2Error)

	/// Invalid operation or input
	case invalidOperation(libgit2Error: Libgit2Error)

	/// Uncommitted changes in index prevented operation
	case uncommitedChanges(libgit2Error: Libgit2Error)

	/// The operation is not valid for a directory
	case invalidDirectory(libgit2Error: Libgit2Error)

	/// A merge conflict exists and cannot continue
	case mergeConflict(libgit2Error: Libgit2Error)

	/// Signals end of iteration with iterator
	case endOfIteration(libgit2Error: Libgit2Error)

	/// Hashsum mismatch in object
	case hashMismatch(libgit2Error: Libgit2Error)

	/// Object has an unrecognized type
	case unknownObjectType(git_object_t, OID)

	/// Could not compute diff
	case diffError

	public var description: String {
		if let underlyingError = underlyingError {
			return underlyingError.description
		}
		switch self {
		case .unknownObjectType(let type, let oid):
			return "Unrecognized git_otype '\(type)' for oid '\(oid)'."
		case .diffError:
			return "Diff Error"
		default:
			return "Unknown"
		}
	}

	/// Initialize a `SwiftGit2Error` with an error code originating in libgit2.
	/// An error message will be obtained from libgit2 using the
	/// `git_error_last` method.
	///
	/// :param: code An error code returned by a libgit2 function.
	/// :param: source The libgit2 method that produced the
	///         error code.
	/// :returns: An appropriate `SwiftGit2Error` with an underlying libgit2 error code and corresponding source message.
	internal init(libgitErrorCode code: Int32, source: Libgit2Method) {
		let libgit2Error = Libgit2Error(errorCode: code, source: source)
		switch git_error_code(code) {
		case GIT_ENOTFOUND:
			self = .objectNotFound(libgit2Error: libgit2Error)
		case GIT_EEXISTS:
			self = .objectAlreadyExists(libgit2Error: libgit2Error)
		case GIT_EAMBIGUOUS:
			self = .multipleObjectsExist(libgit2Error: libgit2Error)
		case GIT_EBUFS:
			self = .outputBufferTooShort(libgit2Error: libgit2Error)
		case GIT_EUSER:
			self = .userContext(libgit2Error: libgit2Error)
		case GIT_EBAREREPO:
			self = .bareRepo(libgit2Error: libgit2Error)
		case GIT_EUNBORNBRANCH:
			self = .headWithoutCommits(libgit2Error: libgit2Error)
		case GIT_EUNMERGED:
			self = .mergeInProgress(libgit2Error: libgit2Error)
		case GIT_ENONFASTFORWARD:
			self = .referenceNotFastForwardable(libgit2Error: libgit2Error)
		case GIT_EINVALIDSPEC:
			self = .invalidSpec(libgit2Error: libgit2Error)
		case GIT_ECONFLICT:
			self = .checkoutConflicts(libgit2Error: libgit2Error)
		case GIT_ELOCKED:
			self = .fileLocked(libgit2Error: libgit2Error)
		case GIT_EMODIFIED:
			self = .unexpectedReferenceValue(libgit2Error: libgit2Error)
		case GIT_EAUTH:
			self = .authenticationError(libgit2Error: libgit2Error)
		case GIT_ECERTIFICATE:
			self = .invalidServerCertificate(libgit2Error: libgit2Error)
		case GIT_EAPPLIED:
			self = .alreadyApplied(libgit2Error: libgit2Error)
		case GIT_EPEEL:
			self = .peelNotPossible(libgit2Error: libgit2Error)
		case GIT_EEOF:
			self = .endOfFile(libgit2Error: libgit2Error)
		case GIT_EINVALID:
			self = .invalidOperation(libgit2Error: libgit2Error)
		case GIT_EUNCOMMITTED:
			self = .uncommitedChanges(libgit2Error: libgit2Error)
		case GIT_EDIRECTORY:
			self = .invalidDirectory(libgit2Error: libgit2Error)
		case GIT_EMERGECONFLICT:
			self = .mergeConflict(libgit2Error: libgit2Error)
		case GIT_ITEROVER:
			self = .endOfIteration(libgit2Error: libgit2Error)
		case GIT_EMISMATCH:
			self = .hashMismatch(libgit2Error: libgit2Error)
		case GIT_ERROR, GIT_PASSTHROUGH, GIT_RETRY:
			self = .genericError(libgit2Error: libgit2Error)
		default:
			self = .genericError(libgit2Error: libgit2Error)
		}
	}

	public var underlyingError: Libgit2Error? {
		switch self {
		case .genericError(let libgit2Error),
			 .objectNotFound(let libgit2Error),
			 .objectAlreadyExists(let libgit2Error),
			 .multipleObjectsExist(let libgit2Error),
			 .outputBufferTooShort(let libgit2Error),
			 .userContext(let libgit2Error),
			 .bareRepo(let libgit2Error),
			 .headWithoutCommits(let libgit2Error),
			 .mergeInProgress(let libgit2Error),
			 .referenceNotFastForwardable(let libgit2Error),
			 .invalidSpec(let libgit2Error),
			 .checkoutConflicts(let libgit2Error),
			 .fileLocked(let libgit2Error),
			 .unexpectedReferenceValue(let libgit2Error),
			 .authenticationError(let libgit2Error),
			 .invalidServerCertificate(let libgit2Error),
			 .alreadyApplied(let libgit2Error),
			 .peelNotPossible(let libgit2Error),
			 .endOfFile(let libgit2Error),
			 .invalidOperation(let libgit2Error),
			 .uncommitedChanges(let libgit2Error),
			 .invalidDirectory(let libgit2Error),
			 .mergeConflict(let libgit2Error),
			 .endOfIteration(let libgit2Error),
			 .hashMismatch(let libgit2Error):
			return libgit2Error
		case .unknownObjectType,
			 .diffError:
			return nil
		}
	}
}
