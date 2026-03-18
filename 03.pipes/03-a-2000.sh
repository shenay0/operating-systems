#С отделни команди, извадете от файл /etc/passwd:
#- първите 12 реда
#- първите 26 символа
#- всички редове, освен последните 4
#- последните 17 реда
#- 151-я ред (или друг произволен, ако нямате достатъчно редове)
#- последните 4 символа от 13-ти ред (символът за нов ред не е част от реда)

cat /etc/passwd | head -n 12
cat /etc/passwd | head -n 1 | cut -c -12
cat /etc/passwd | head -n -4
cat /etc/passwd | tail -n 17
cat /etc/passwd | head -n 153 | tail -n 1
cat /etc/passwd | head -n 13 | tail -c 5

