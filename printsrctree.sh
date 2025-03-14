# /bin/bash

# Usage: printjavasrctree src-root-dir project-name
#
# Acha todos os arquivos .java abaixo de src-root-dir e
# gera um arquivo chamado project-name.pdf com a
# concatenacao de todos os arquivos .java da árvore

if [ $# -ne 2 ]; then
	echo "Usage: printjavasrctree src-root-dir project-name"
	exit
fi
root_dir_path=$1
project_name=$2

rm -f /tmp/source.md
find -L $root_dir_path -name \*.go | grep -v "src/test/java" > /tmp/java-files
while IFS= read -r file_path; do
	file_name=`basename $file_path`
	echo $file_name >> /tmp/source.md
	echo "\`\`\`{include="$file_path" .go .numberLines}" >> /tmp/source.md
	echo "\`\`\`" >> /tmp/source.md
done < /tmp/java-files

pandoc --standalone --lua-filter=`pwd`/include-code-files.lua --output /tmp/output.html --metadata title="$project_name" /tmp/source.md
cat /tmp/output.html | wkhtmltopdf -T 20 -B 20 -L 20 -R 20 - $project_name.pdf

rm /tmp/java-files /tmp/source.md /tmp/output.html
