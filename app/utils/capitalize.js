/** "science fiction" -> "Science Fiction" */
export function capitalize(input) {
  return String(input ?? '')
    .split(/\s+/)
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}
