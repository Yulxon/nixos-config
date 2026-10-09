# Add the large character table and shared dictionaries to Rime Ice.
# Fail visibly if the upstream import_tables layout changes.
/^  # - cn_dicts\/41448([[:space:]]|$)/ {
  sub(/^  # -/, "  -")
  large_table++
}
{ print }
/^  - cn_dicts\/others([[:space:]]|$)/ {
  print "  - zhwiki"
  print "  - moegirl"
  extension_anchor++
}
END {
  if (large_table != 1 || extension_anchor != 1) {
    printf "unexpected rime_ice.dict.yaml layout (41448=%d, others=%d)\n", large_table, extension_anchor > "/dev/stderr"
    exit 1
  }
}
