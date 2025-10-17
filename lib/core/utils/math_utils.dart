/// Returns the total sum of a numeric field from a list of items.
/// [selector] is a function that extracts the numeric value (e.g., e.amount).
double calcTotal<T>(Iterable<T> items, num Function(T) selector) {
  return items.fold<double>(0, (sum, e) => sum + selector(e).toDouble());
}
