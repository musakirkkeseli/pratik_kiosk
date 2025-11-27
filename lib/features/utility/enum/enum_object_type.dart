enum ObjectType { dropdown, integer, string, searchable, unknown }

/// Helper for converting between the backend string and the [ObjectType] enum.
class ObjectTypeHelper {
  static ObjectType fromString(String? value) {
    if (value == null) return ObjectType.unknown;
    switch (value.toLowerCase()) {
      case 'dropdown':
        return ObjectType.dropdown;
      case 'integer':
        return ObjectType.integer;
      case 'string':
        return ObjectType.string;
      case 'searchable':
        return ObjectType.searchable;
      default:
        return ObjectType.unknown;
    }
  }

  /// Returns the backend string for the enum or null if unknown.
  static String? toJson(ObjectType? type) {
    if (type == null) return null;
    switch (type) {
      case ObjectType.dropdown:
        return 'dropdown';
      case ObjectType.integer:
        return 'integer';
      case ObjectType.string:
        return 'string';
      case ObjectType.searchable:
        return 'searchable';
      case ObjectType.unknown:
        return null;
    }
  }
}
