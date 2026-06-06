  1 #!/bin/bash
  2 
  3 echo "<table>"
  4 echo -e "  <tr>\n<th>Username</th>\n    <th>group</th>\n    <th>login shell</th>\n    <th>GECOS</th>\n  </tr>"
  5 
  6 awk -F ':' '
  7         FILENAME == "/etc/group"{
  8             group[$3]=$1
  9         }
 10 
 11         FILENAME == "/etc/passwd" {
 12             username=$1
 13             gid=$4
 14             gecos=$5
 15             shell=$7
 16 
 17             print "  <tr>"
 18             print "    <td>" username "</td>"
 19             print "    <td>" group[gid] "</td>"
 20             print "    <td>" shell "</td>"
 21             print "    <td>" gecos "</td>"
 22             print "  </tr>"
 23         } ' /etc/group /etc/passwd
 24 echo "</table>" 
~

