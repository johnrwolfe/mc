#
# Still need to hand-edit the following:
#  - embedded double-quotes (")
#
filelist=`ls ../../model/masl/gen/masl/t.*.masl | xargs -n1 basename`
for f in $filelist; do
  cat  ../../model/masl/gen/masl/$f | sed "s/^.assign[^\"]*\"\(.*\)\"/\1/" | \
  ./template_engine | \
  awk '{if ($0 ~ "if ") {gsub(" and "," \\&\\& ");gsub(" or ", " || ");gsub(" not "," ! ");gsub("\\.","->");} print $0;}' | \
  sed 's/\(T_b[^"]*\)"\(.*\)"\([^"]*\)/\1\&quot;\2\&quot;\3/' | \
  awk '{if ($0 ~ "T_b") gsub("\"","\\\"");print $0;}' | \
  sed 's/&quot;/"/g' | \
  sed 's/ \("[^"]*"\) == \([^ ]*\) / 0==strcmp(\1,\2) /g' | \
  sed 's/ \("[^"]*"\) != \([^ ]*\) / 0!=strcmp(\1,\2) /g' > ../../model/masl/src/masl/$f
done
