module SlingerDB
  class SlingerDBException < StandardError; end
  class NonExistentRecord < SlingerDBException; end
  class PermissionDeniedException < SlingerDBException; end
  class UnexpectedHTTPException < SlingerDBException; end
end